/**
 * Skeleton file for server.c
 * 
 * You are free to modify this file to implement the server specifications
 * as detailed in Assignment 3 handout.
 * 
 * As a matter of good programming habit, you should break up your imple-
 * mentation into functions. All these functions should contained in this
 * file as you are only allowed to submit this file.
 */ 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
//#include <arpa/inet.h>
#include <sys/socket.h>
// #include <sys/types.h>
#include <netinet/in.h>
#include <sys/wait.h>
#include <stdbool.h>
#include <ctype.h>
#include <limits.h>

#define BUFFER_SIZE 1024
#define MAX_PENDING 5

/**
 * The main function should be able to accept a command-line argument
 * argv[0]: program name
 * argv[1]: port number
 * 
 * Read the assignment handout for more details about the server program
 * design specifications.
 */ 

int main(int argc, char *argv[]) {
    int server_port;
    struct sockaddr_in server_address, client_address;
    socklen_t client_address_length = sizeof(client_address);
    int server_socket, client_socket;
    char buffer[BUFFER_SIZE];

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <port>\n", argv[0]);
        return -1;
    }
    server_port = atoi(argv[1]);
    if (server_port < 1024) {
        fprintf(stderr, "Port number must be greater than or equal to 1024.\n");
        return -1;
    }

    // create socket
    if ((server_socket = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("Error creating socket");
        return -1;
    }

    // bind socket to server address and port
    memset(&server_address, 0, sizeof(server_address));
    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = htonl(INADDR_ANY);
    server_address.sin_port = htons(server_port);
    if (bind(server_socket, (struct sockaddr *) &server_address, sizeof(server_address)) < 0) {
        perror("Error binding socket");
        close(server_socket);
        return -1;
    }

    // listen for connections
    if (listen(server_socket, MAX_PENDING) < 0) {
        perror("Error listening on socket");
        close(server_socket);
        return -1;
    }

    while (1) {
        // accept connections
        if ((client_socket = accept(server_socket, (struct sockaddr *) &client_address, &client_address_length)) < 0) {
            perror("Error accepting connection");
            close(server_socket);
            return -1;
        }

        // HELLO message to client
        sprintf(buffer, "HELLO\n");
        if (send(client_socket, buffer, strlen(buffer), 0) < 0) {
            perror("Error sending message");
            close(client_socket);
            continue; 
        }

        // wait for message from client
        memset(buffer, 0, BUFFER_SIZE);
        int bytes_received = recv(client_socket, buffer, BUFFER_SIZE, 0);
        if (bytes_received < 0) {
            perror("Error receiving message");
            close(client_socket);
            continue;
        }

        printf("Received message from client: %s", buffer);

        // if message is bye/BYE/Bye, shut the connection
        if (strncasecmp(buffer, "BYE", 3) == 0) {
            close(client_socket); // close the connection with the current client
            }
        else if (strncasecmp(buffer, "GET", 3) == 0) { // message is GET filename.txt
            char *file_name = strtok(buffer + 4, " \n");
            if(file_name != NULL) {
                FILE *file = fopen(file_name, "r"); // reading
                if (file != NULL) {
                    char ok_message[] = "SERVER 200 OK\n\n";
                    send(client_socket, ok_message, strlen(ok_message), 0);

                    char file_buffer[BUFFER_SIZE];
                    size_t bytes_read;
                    while((bytes_read = fread(file_buffer, 1, sizeof(file_buffer), file)) > 0) {
                        send(client_socket, file_buffer, bytes_read, 0);
                    }
                    char new_line[] = "\n\n";
                    send(client_socket, new_line, strlen(new_line), 0);

                    fclose(file);
                }
                else { // if the opening is not successful - send to client
                    char error_message[] = "SERVER 404 Not Found\n";
                    send(client_socket, error_message, strlen(error_message), 0);
                }
            }
            else { // other error encountered (no file name is specified in the GET message)
                char error_message[] = "SERVER 500 Get Error\n";
                send(client_socket, error_message, strlen(error_message), 0);
            }
        }
        // PUT filename.txt
        else if (strncasecmp(buffer, "PUT", 3) == 0) {            
            char *file_name = strtok(buffer + 4, "\r\n");
            if (file_name != NULL) {
                char full_path[PATH_MAX];
                snprintf(full_path, PATH_MAX, "./%s", file_name);
                FILE *file = fopen(full_path, "w");
                if (file != NULL) {
                    char ok_message[] = "SERVER 201 Created\n";
                    send(client_socket, ok_message, strlen(ok_message), 0);

            char buffer[BUFFER_SIZE];
                    bool last_was_newline = false;
                    ssize_t bytes_received;
                    while ((bytes_received = recv(client_socket, buffer, BUFFER_SIZE, 0)) > 0) {
                        buffer[bytes_received] = '\0';
                        fputs(buffer, file);
                        last_was_newline = (bytes_received >= 2 && buffer[bytes_received-2] == '\n' && buffer[bytes_received-1] == '\n');
                        if (last_was_newline) {
                            break;
                            }
                    }
                    fputs("\n\n", file);
                    fclose(file);
                    
                    if (last_was_newline) {
                    char ok_message[] = "SERVER 201 Created\n";
                    send(client_socket, ok_message, strlen(ok_message), 0);
                    } else { // no file name specified 
                        char error_message[] = "SERVER 502 Command Error\n";
                        send(client_socket, error_message, strlen(error_message), 0);
                    }
                } 
                else { // failure to open file
                    char error_message[] = "SERVER 501 Put Error\n";
                    send(client_socket, error_message, strlen(error_message), 0);
                }
            } 
            else { // failure to open file
                char error_message[] = "SERVER 501 Put Error\n";
                send(client_socket, error_message, strlen(error_message), 0);
            }
        }
    }
}
                 
            
                    
                       
                    
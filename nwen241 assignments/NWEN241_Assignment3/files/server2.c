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
#include <arpa/inet.h>
#include <sys/socket.h>
// #include <sys/types.h>
#include <netinet/in.h>
#include <sys/wait.h>
#include <stdbool.h>
#include <ctype.h>
#include <limits.h>

#define MAX_LINE 1024
#define MAX_PENDING 5

/**
 * The main function should be able to accept a command-line argument
 * argv[0]: program name
 * argv[1]: port number
 * 
 * Read the assignment handout for more details about the server program
 * design specifications.
 */ 

void deal_with_client(int client_socket);

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <port>\n", argv[0]);
        return -1;
    }

    int server_socket, client_socket, port;
    struct sockaddr_in server_address, client_address;
    char buffer[MAX_LINE];

    // create socket for the server
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket < 0) {
        perror("Error creating socket");
        return -1;
    }

    // bind the socket to a specific port
    memset(&server_address, 0, sizeof(server_address));
    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = htonl(INADDR_ANY);
    port = atoi(argv[1]);
    server_address.sin_port = htons(port);

    if (bind(server_socket, (struct sockaddr*) &server_address, sizeof(server_address)) < 0) {
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

    printf("Server listening on port %d...\n", port);

    while (1) {
        // accept a new client connection
        memset(&client_address, 0, sizeof(client_address));
        unsigned int client_address_length = sizeof(client_address);
        client_socket = accept(server_socket, (struct sockaddr*) &client_address, &client_address_length);
        if (client_socket < 0) {
            perror("Error accepting client connection");
            close(server_socket);
            return -1;
        }

        printf("Client connected from %s:%d\n", inet_ntoa(client_address.sin_addr), ntohs(client_address.sin_port));

        // fork a child process - deal with the client request
        int pid = fork();
        if (pid < 0) {
            perror("Error forking child process");
            close(client_socket);
            continue;
        } else if (pid > 0) {
            // parent process
            close(client_socket); // close the client socket
            continue; // continue listening
        } else {
            // child process: handle the client request
            close(server_socket); // close server socket

            // Send a HELLO message to the client
            if (send(client_socket, "HELLO\n", 6, 0) < 0) {
                perror("Error sending message to client");
                close(client_socket);
                exit(1);
            }

            while (1) {
                // wait for a message from the client
                memset(buffer, 0, MAX_LINE);
                int bytes_received = recv(client_socket, buffer, MAX_LINE, 0);
                if (bytes_received < 0) {
                    perror("Error receiving message from client");
                    close(client_socket);
                    exit(1);
                } else if (bytes_received == 0) {
                    printf("Client disconnected\n");
                    close(client_socket);
                    exit(0);
                }

                // deal with client's message
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

                                char file_buffer[MAX_LINE];
                                size_t bytes_read;
                                while((bytes_read = fread(file_buffer, 1, sizeof(file_buffer), file)) > 0) {
                                    send(client_socket, file_buffer, bytes_read, 0);
                                }
                                char new_line[] = "\n\n";
                                send(client_socket, new_line, strlen(new_line), 0);

                                fclose(file);
                            } else { // if the opening is not successful - send to client
                            char error_message[] = "SERVER 404 Not Found\n";
                            send(client_socket, error_message, strlen(error_message), 0);
                            }
                        } else { // other error encountered (no file name is specified in the GET message)
                        char error_message[] = "SERVER 500 Get Error\n";
                        send(client_socket, error_message, strlen(error_message), 0);
                        }
                    }
            }
        }
    }
}
                    

                     
            
                    
                       
                    
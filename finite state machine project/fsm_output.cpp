#include <iostream>
using namespace std;
string state;
string input;
int accept = 0;
int Proc(char in_char)
{
if(state == "S0"){
    if(in_char == 'c'){
        state ="S1";
    }
    if(in_char == 'a'){
        state ="S0";
    }
    if(in_char == 't'){
        state ="S0";
    }
    if(in_char == 'n'){
        state ="S0";
    }

    }

else if(state == "S1"){
    if(in_char == 'c'){
        state ="S1";
    }
    if(in_char == 'a'){
        state ="S2";
    }
    if(in_char == 'n'){
        state ="S2";
    }

    }

else if(state == "S2"){
    if(in_char == 't'){
        state ="S3";
        accept = 1;
    }
    if(in_char == 'n'){
        state ="S0";
    }

    }

else if(state == "S3"){
}
return accept;
}
int main(){
state = "S0";
cout<<" state="<<state<<" enter signal"<<endl;
cin>>input;
for (char s:input){
Proc(s);
}
cout<<" new state ="<<state<<endl;
cout<<" accepted = "<<accept<<endl;
}

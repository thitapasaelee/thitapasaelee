#include "out.h"
 
using namespace std;

int counter = 0;
string state;
string tempString;
// string token;
struct Transition tempTransition;
struct State tempState;
struct FSM_out tempFSMOut;
// FSM_out myFSM;
    
int ProcessChar(char in_char){
if(state == "s0"){
	if(in_char == 'i'){
		state = "s1";
		} else if(in_char == 's'){
			state = "s5";
			//State newState;
			//myFSM.state_in_progress = newState;
		} else if(in_char == 'a'){
			state = "s3";
		} else {
			state = "error";
		}
	}
else if(state == "s1"){
   if(in_char == '{'){
       state = "s2";
       } else {
		   state = "error";
		   }
} 
else if(state == "s2"){
   if(in_char == '}'){
     state = "s0";
     //myFSM.initial_name = token;
     // token.clear();
     } else if (in_char != '}'){
        state = "s2";
        tempFSMOut.initial_name += in_char;
        //token.push_back(in_char);
      }
 } else
if(state == "s3"){
	if(in_char == '{'){
		//token.clear();
		state = "s4";
		} else {
			state = "error";
			}
}else 
if(state == "s4"){
	if(in_char == '}'){
		state = "s0";
		//myFSM.initial_name = token;
		// token.clear(); 
	} else if (in_char != '}'){
		state = "s4";
		tempFSMOut.accepting_name += in_char;
		// token.push_back(in_char);
	}
}else
if(state == "s5"){
	if(in_char == '{'){
		//token.clear();
		state = "s6";
		} else {
			state = "error";
			}
}else
if(state == "s6"){
	if(in_char == 'n'){
		state = "s7";
		} else {
			state = "error";
	}
}else
if(state == "s7"){
	if(in_char == '{'){
		tempState.name = "";
		// token.clear();
		state = "s8";
		} else {
			state = "error";
			}
}else
if(state == "s8"){
   if(in_char == '}'){
     state = "s9";
     // myFSM.state_in_progress.name = token; //
     } else if (in_char != '}'){
        state = "s8";
        tempState.name += in_char;
        // token.push_back(in_char);
      }
 }else
 if(state == "s9"){
	 if(in_char == 't'){
		 state = "s10";
		 if (counter == 0){
                tempString += R"(if(state == ")"; // print if
                counter += 1;
            }
            else{
                tempString += R"(else if(state == ")"; // print else-if
            }
            tempString += tempState.name;
            tempString += R"("){)";
            code.push_back(tempString);
            tempTransition.input_signal = "";
            tempString = "";
            } 
            else if(in_char == '}'){
			tempString += R"(else if(state == ")";
			tempString += tempState.name;
			tempString += R"("){)";
			code.push_back(tempString);
			code.push_back("}");
			code.push_back("return accept;");
			code.push_back("}");
			tempTransition.input_signal = "";
			tempString = "";
			}
			else {
			state = "error";
		}
}else
 if(state == "s10"){
	 if(in_char == '{'){
		//token.clear();
		state = "s11";
		} else {
			state = "error";
			}
} else
if(state == "s11"){
	if(in_char == 'i'){
		state = "s12";
		} else {
			state = "error";
		    }
}else
if(state == "s12"){
	if(in_char == '{'){
		tempTransition.input_signal= "";
		state = "s13";
		} else {
			state = "error";
			}
}else
if(state == "s13"){
   if(in_char == '}'){
     state = "s14";
     // myFSM.state_in_progress.transitions.back().input_signal = token; //
     } else if (in_char != '}'){
		tempTransition.input_signal += in_char;
        state = "s13";
        // token.push_back(in_char);
      }
}else
 if(state == "s14"){
	 if(in_char == 'd'){
		 tempString += R"(    if(in_char == ')";
		 tempString += tempTransition.input_signal;
         tempString += R"('){)";
         code.push_back(tempString);
         tempTransition.input_signal = "";
         tempString = "";
		 state = "s15";
		 } else {
			 state = "error";
	 }
} else
 if(state == "s15"){
	if(in_char == '{'){
		tempTransition.dest_state = "";
		// token.clear();
		state = "s16";
		} else {
			state = "error";
			}
}else
if(state == "s16"){
   if(in_char == '}'){
     state = "s17";
     // myFSM.state_in_progress.transitions.back().dest_state = token; //
     // myFSM.initial_name = token;
     } else if (in_char != '}'){
		tempTransition.dest_state += in_char;
        state = "s16";
        // token.push_back(in_char);
      }
 }
 else if (state == "s17"){
	 if(in_char == '}'){
		 tempString += R"(        state =")";
         tempString += tempTransition.dest_state;
         tempString += R"(";)";
         code.push_back(tempString);
         if (tempTransition.dest_state == tempFSMOut.accepting_name){
			 code.push_back("        accept = 1;");
			 }
			 code.push_back("    }");
             tempTransition.input_signal = "";
             tempString = "";
		     state = "s18";
		 }
}
else if(state == "s18"){
	 if(in_char == '}'){
         code.push_back(tempString);
         if (tempTransition.dest_state == tempFSMOut.accepting_name){
			 code.push_back("        accept = 1;");
			 }
			 code.push_back("    }");
             tempTransition.input_signal = "";
             tempString = "";
		     // myFSM.initial_name = token; 
		 } else if(in_char == 't'){
			 state = "s10";
			 } else if(in_char == 's'){
				 state = "s5";
				 // code.push_back("}");
				 code.push_back("");
				 } else {
					 state = "error";
					 }
}else if (state == "error"){
	cout<<"error"<<endl;
	}
	return 0;
}

int main(){
    state = "s0";
	string input;
	cout<<"enter filename :";
	getline(std::cin,input);
	string sp = ReadSpecFile(input);
	//std::cout<<s<<endl;
	//std::cout<<"\n\n\n";
	// for (int i = 0; i < s.length(); i++){

	code.push_back("#include <iostream>");
	code.push_back("using namespace std;");
	code.push_back("string state;");
	code.push_back("string input;");
	code.push_back("int accept = 0;");
	code.push_back("int Proc(char in_char)");
	code.push_back("{");
	for(char s: sp){
		ProcessChar(s);
}
	code.push_back("int main(){");
	tempString = R"(state = ")";
	tempString += tempFSMOut.initial_name;
	tempString += R"(";)";
	code.push_back(tempString);
	code.push_back(R"(cout<<" state="<<state<<" enter signal"<<endl;)");
	code.push_back("cin>>input;");
	code.push_back("for (char s:input){");
	code.push_back("Proc(s);");
	code.push_back("}");
	code.push_back(R"(cout<<" new state ="<<state<<endl;)");
	code.push_back(R"(cout<<" accepted = "<<accept<<endl;)");
	code.push_back("}");
    SaveCodeFile("fsm_output.cpp");
}

//vector<string> write_code(const FSM_out myFSM){ 
    //vector<string> code;
    // for(State s : myFSM.states);//
    //for(unsigned int i = 0; i < myFSM.states.size(); i++){
		//code.push_back("if (state == "+myFSM.states.at(i).name+"){");
		//for(Transition t : myFSM.states.at(i).transitions){
			//for(unsigned int j = 0; i < myFSM.states.at(i).transitions.size(); j++){ // i < or j <
			//code.push_back("if (input == " +myFSM.states.at(i).transitions.at(i).input_signal+ ") {state == " + t.dest_state+ "; }");
			//cout<<"if (input == " +t.input_signal+ ") { state == " + t.dest_state + "; }"; 
			//}
			//code.push_back("}");
		//}
		//code.push_back("} else (error{" "error");
		//}
		//return code; 
	//}









#include <iostream>

void func3(){
    std::cout << "function 3" << std::endl;    
}

void func2(){
    std::cout << "function 2" << std::endl;    
    func3();
}

void func1(){
    std::cout << "function 1" << std::endl;    
    func2();
}

int main(){
    func1();
    return 0;
}
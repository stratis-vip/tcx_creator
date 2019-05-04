#include <iostream>
#include "tcxobject.hpp"

int main(int argc, char *argv[])
{
     TcxObject tcx{true, "en", "2.4"};
    // TcxObject tcx{false};
    std::cout << tcx.print() << std::endl;
    if (!tcx.isEmpty())
    {
        
        std::cout << "Version: " << tcx.getVersion() << std::endl;
    }
    return 0;
}
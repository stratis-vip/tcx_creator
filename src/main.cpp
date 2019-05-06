#include "infostructure.hpp"
#include "options.hpp"
#include "tcxobject.hpp"
#include <iostream>

int main(int argc, char *argv[]) {
  Info of;
  of.id = "1";
  of.distance = 12345;
  of.lapsEvery = 1000;
  // TcxObject tcx{"/Users/stratis/Desktop/dev/c++/tcx_creator/options.json"};
  TcxObject tcx{"/home/stratis/dev/c++/tcx_creator/options.json"};
  // tcx.addActivity("2017-10-29T07:11:03.000Z","Cycling");

  // TcxObject tcx{false};
  std::cout << tcx.print() << std::endl;
  // Options opt("/Users/stratis/Desktop/dev/c++/tcx_creator/options.json");
  if (!tcx.isEmpty()) {

    std::cout << "Version: " << tcx.getVersion() << std::endl;
  }
  // std::cout << opt.getId() << std::endl;
  return 0;
}
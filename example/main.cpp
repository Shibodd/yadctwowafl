#include <iostream>
#include <random>

#include <Windows.h>

int main() {
  std::mt19937_64 re;
  std::cout << re() << std::endl;

  std::cout << CreateFileMappingA(NULL, NULL, 0, 0, 0, NULL) << std::endl;
}
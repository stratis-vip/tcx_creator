#include "options.hpp"

std::string getCurrentDateTimeAsId(time_t timeToConvert)
{
  if (timeToConvert == 0)
    timeToConvert = std::time(nullptr);
  auto tm = *std::gmtime(&timeToConvert);

  std::ostringstream oss;
  oss << std::put_time(&tm, "%Y-%m-%dT%H:%M:%S.000Z"); //2017-10-29T07:11:03.000Z

  return oss.str();
}

json readFromFile(const std::string fileName)
{
  std::ifstream in(fileName);
  json j;
  if (in.is_open())
  {
    in >> j;
    // _sport = j["sport"];
  }
  return j;
}
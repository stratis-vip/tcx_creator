#ifndef options_hpp
#define options_hpp

#include <ctime>
#include <iomanip>
#include <sstream>
#include <fstream>
#include "json.hpp"
#include <vector>
#include "infostructure.hpp"

using json = nlohmann::json;

std::string getCurrentDateTimeAsId(time_t timeToConvert = 0);
json readFromFile(const std::string fileName);





class Options
{
public:
  Options(std::string fileName)
  {
    json j = readFromFile(fileName);
    //_id = getCurrentDateTimeAsId(j["id"]);
    auto ar = j["activities"];

    for (auto r : ar)
    {
      Info f;
      f.id = getCurrentDateTimeAsId(r["id"]);
      f.sport = r["sport"];
      f.distance = r["distance"];
      f.lapsEvery = r["lapsEvery"];
      activitiesInfo.push_back(f);
    }
    _encoding = j["encoding"];
    _version = j["version"];
  }

  // const std::string getId(const size_t activityIndex) const
  // {
  //   if (activityIndex < activitiesCount())
  //     return activitiesInfo[activityIndex].id;
  //   return getCurrentDateTimeAsId();
  // }

  // const std::string getSportType(const size_t activityIndex) const
  // {
  //   if (activityIndex < activitiesCount())
  //     return activitiesInfo[activityIndex].sport;
  //   return "Generic";
  // }

  const std::string getEncoding() const
  {
    return _encoding;
  }

  const std::string getVersion() const
  {
    return _version;
  }

  // const size_t getDistance(const size_t activityIndex) const
  // {
  //   if (activityIndex < activitiesCount())
  //     return activitiesInfo[activityIndex].distance;
  //   return 0;
  // }
  Info operator[](const size_t idx) { return activitiesInfo[idx]; }
  std::vector<Info>::iterator begin() { return activitiesInfo.begin(); }
  std::vector<Info>::iterator end() { return activitiesInfo.end(); }

  const size_t activitiesCount() const
  {
    return activitiesInfo.size();
  }

private:
  std::string _encoding{"UTF-8"};
  std::string _version{"1.0"};
  json _jsonOptions;
  std::vector<Info> activitiesInfo{};
  //     = R"({
  //   "id": 0,
  //   "sport": "Running"
  // })"_json;
};

#endif
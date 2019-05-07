#ifndef activity_hpp
#define activity_hpp

#include "infostructure.hpp"
#include "options.hpp"
#include "pugixml.hpp"

using namespace pugi;

const static size_t LAP_RUNNING = 1000;

class Activity {
public:
  Activity() = default;

  void loadInfo(const Info &infoStruct) const {
    *_act = _node->append_child("Activity");
    addSportAttribute(infoStruct.sport.c_str());
    addIdTag(getCurrentDateTimeAsId(infoStruct.id));
    const size_t distance = infoStruct.distance;
    const size_t lapsEvery = infoStruct.lapsEvery;
    size_t laps = lapsEvery == 0 ? 1 : distance / lapsEvery;
    double lapTime = 1.0 * infoStruct.totalTimeInSeconds *
                     infoStruct.lapsEvery / infoStruct.distance;
    double extra_time = infoStruct.totalTimeInSeconds - laps * lapTime;
    if (distance - laps * lapsEvery >
        0) // if distance is not exactly "laps" laps, add 1 lap for the rest
      laps++;
    size_t lapCount{0};
    for (size_t _ = 0; _ != laps; _++) {
      xml_node lap = _act->append_child("Lap");
      // xml_attribute lapAttribute =
      lap.append_attribute("StartTime") =
          getCurrentDateTimeAsId(infoStruct.id + lapCount * lapTime).c_str();
      // lapAttribute.value("test");
      auto totalTimeTag = lap.append_child("TotalTimeSeconds");
      auto text = totalTimeTag.append_child(node_pcdata);
      // text.set_name("Id");
      text.set_value(std::to_string(lapTime).c_str());
      extra_time++;
      lapCount++;
    }
    _act->append_child("Creator");
  }
  Activity(const Info &infoStruct)
      : _id(getCurrentDateTimeAsId(infoStruct.id).c_str()),
        _sport(infoStruct.sport.c_str()) {
    loadInfo(infoStruct);
  }

  ~Activity() {
    delete _act;
    delete _node;
  }

  const xml_node getNode() { return *_act; }

  void setSportType(const char *sportType) const {
    _act->attribute("Sport") = sportType;
  }

  const char *getSportType() const { return _act->attribute("Sport").value(); }

  const char *getId() const { return _act->child("Id").first_child().value(); }

  const size_t getLapsCount() {
    return std::distance(_act->children("Lap").begin(),
                         _act->children("Lap").end());
  }

private:
  xml_node *_node = new xml_document();
  xml_node *_act = new xml_node();

  const char *_id;
  const char *_sport;

  void addSportAttribute(const std::string &sport) const {
    _act->append_attribute("Sport") = sport.c_str();
  }

  void addIdTag(const std::string &id) const {
    auto idTag = _act->append_child("Id");
    auto text = idTag.append_child(node_pcdata);
    text.set_value(id.c_str());
  }
};

#endif
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
  void loadInfo(Info infoStruct) const {
    *_act = _node->append_child("Activity");
    addSportAttribute(infoStruct.sport.c_str());
    addIdTag(infoStruct.id);
    const size_t distance = infoStruct.distance;
    const size_t lapsEvery = infoStruct.lapsEvery;
    const size_t laps = lapsEvery == 0 ? 1 : distance / lapsEvery;
    for (size_t _ = 0; _ != laps; _++) {
      xml_node lap = _act->append_child("Lap");
      lap.append_attribute("StartTime");
    }
    _act->append_child("Creator");
  }
  Activity(Info infoStruct)
      : _id(infoStruct.id.c_str()), _sport(infoStruct.sport.c_str()) {
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
    text.set_name("Id");
    text.set_value(id.c_str());
  }
};

#endif
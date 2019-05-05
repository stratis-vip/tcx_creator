#ifndef tcxobject_hpp
#define tcxobject_hpp

#include "pugixml.hpp"
#include <string>
#include <sstream>
#include <iostream>
#include "activity.hpp"
#include "options.hpp"
#include "infostructure.hpp"

using namespace pugi;

class TcxObject
{
public:
  TcxObject()
  {
    _doc->reset();
    _decl = new xml_node();
    *_decl = _doc->prepend_child(node_declaration);
    saveDoc();
  };

  TcxObject(const std::string fileName):TcxObject(){
    Options opt(fileName);
    makeDeclaration(_decl, opt.getVersion(), opt.getEncoding());
    *_root = _doc->append_child("TrainingCenterDatabase");
    *_activities = _root->append_child("Activities");
    _root->append_child("Author");
    for (auto act:opt)
    {
      addActivity(act);
    }
    saveDoc();
  }


  void addActivity(const Info infoStruct)  
  {
    Activity *act = new Activity(infoStruct);
    _activities->append_copy(act->getNode());

    delete act;
    saveDoc();
  }

  ~TcxObject()
  {
    delete _author;
    delete _activities;
    delete _root;
    delete _decl;
    delete _doc;
  }

  std::string getVersion() const
  {
    return getAttributeStringValue(_decl, "version");
  }

  std::string getEncoding() const
  {
    return getAttributeStringValue(_decl, "encoding");
  }

  bool isEmpty()
  {
    size_t countNodes = std::distance(_doc->begin(), _doc->end());
    return countNodes == 0;
  }

  std::string print() const
  {
    return os.str();
  }

  bool hasRoot() const
  {
    return _root != nullptr;
  }

  bool hasActivities() const
  {
    return _activities != nullptr;
  }

private:
  void saveDoc() { _doc->save(os); }
  xml_document *_doc = new xml_document();
  xml_node *_decl = nullptr;
  xml_node *_root = new xml_node();
  xml_node *_activities = new xml_node();
  xml_node *_author = new xml_node();

  std::stringstream os{};

  void makeDeclaration(xml_node *node, const std::string version, const std::string encoding)
  {
    node->append_attribute("version") = version.c_str();
    node->append_attribute("encoding") = encoding.c_str();
  }

  std::string getAttributeStringValue(xml_node *node, const char *val) const
  {
    std::string ret_val{};
    if (node)
      ret_val = node->attribute(val).value();
    return ret_val;
  }
};

#endif

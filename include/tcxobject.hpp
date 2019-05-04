#ifndef tcxobject_hpp
#define tcxobject_hpp

#include "pugixml.hpp"
#include <string>
#include <sstream>
#include <iostream>

using namespace pugi;

class TcxObject
{
public:
  TcxObject(const bool makeFull = true, const char *encoding = "UTF-8",
            const char *version = "1.0")
  {
    _doc->reset();
    if (makeFull)
    {
      _decl = new xml_node();
      *_decl = _doc->prepend_child(node_declaration);
      _decl->append_attribute("version") = version;
      _decl->append_attribute("encoding") = encoding;
    }
    _doc->append_child("TrainingCenterDatabase");
    saveDoc();
  };

  ~TcxObject()
  {
    if (_decl)
    {
      free(_decl);
      _decl = nullptr;
    }
    free(_doc);
  }

  std::string getVersion() const
  {
    return getAttributeStringValue(_decl, "version");
  }

  std::string getEncoding() const
  {
    return getAttributeStringValue(_decl, "encoding");
  }

  std::string getAttributeStringValue(xml_node *node, const char *val) const
  {
    std::string ret_val{};
    if (node)
      ret_val = node->attribute(val).value();
    return ret_val;
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
  
  bool hasRoot() const {
    return _doc->child("TrainingCenterDatabase") != nullptr;
  }
private:
  void saveDoc() { _doc->save(os); }
  xml_document *_doc = new xml_document();
  xml_node *_decl = nullptr;
  std::stringstream os{};
};

#endif

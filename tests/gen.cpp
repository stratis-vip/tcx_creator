#include "gmock/gmock.h"
#include "tcxobject.hpp"

using namespace testing;

class TestCreateEmptyClass : public Test
{
public:
  TcxObject tclass{false};
};

class TestCreateClass : public Test
{
public:
  TcxObject tclass{true, "UTF-8", "2.5"};
};

TEST_F(TestCreateEmptyClass, Declaration)
{
  ASSERT_THAT(tclass.print(), Eq(R"(<?xml version="1.0"?>
)"));
  ASSERT_THAT(tclass.getVersion(), Eq(""));
  ASSERT_THAT(tclass.getEncoding(), Eq(""));
}

TEST_F(TestCreateEmptyClass, IsEmptyTrue)
{
  ASSERT_THAT(tclass.isEmpty(), Eq(true));
}

TEST_F(TestCreateClass, Declaration)
{
  ASSERT_THAT(tclass.print(), Eq(R"(<?xml version="2.5" encoding="UTF-8"?>
)"));
  ASSERT_THAT(tclass.getVersion(), Eq("2.5"));
  ASSERT_THAT(tclass.getEncoding(), Eq("UTF-8"));
}

TEST_F(TestCreateClass, IsEmptyFalse)
{
  ASSERT_THAT(tclass.isEmpty(), Eq(false));
}

TEST_F(TestCreateClass, HasRootNode)
{
  ASSERT_THAT(tclass.hasRoot(), Eq(false));
}
int main(int argc, char **argv)
{
  ::testing::InitGoogleTest(&argc, argv);

  return RUN_ALL_TESTS();
}

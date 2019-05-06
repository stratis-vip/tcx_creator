#include "gmock/gmock.h"
#include "tcxobject.hpp"


using namespace testing;

class TestCreateEmptyClass : public Test
{
public:
  TcxObject tclass{};
};

class TestCreateClass : public Test
{
public:
  TcxObject tclass{"/Users/stratis/Desktop/dev/c++/tcx_creator/options.json"};
};

TEST_F(TestCreateEmptyClass, Declaration)
{
  ASSERT_THAT(tclass.getVersion(), Eq(""));
  ASSERT_THAT(tclass.getEncoding(), Eq(""));
}

TEST_F(TestCreateEmptyClass, IsEmptyTrue)
{
  ASSERT_THAT(tclass.isEmpty(), Eq(false));
}

TEST_F(TestCreateClass, Declaration)
{
  ASSERT_THAT(tclass.getVersion(), Eq("3.9"));
  ASSERT_THAT(tclass.getEncoding(), Eq("UTF-8"));
}

TEST_F(TestCreateClass, IsEmptyFalse)
{
  ASSERT_THAT(tclass.isEmpty(), Eq(false));
}

TEST_F(TestCreateClass, HasRootNode)
{
  ASSERT_THAT(tclass.hasRoot(), Eq(true));
}


TEST_F(TestCreateClass, HasActivitiesNode)
{
  ASSERT_THAT(tclass.hasActivities(), Eq(true));
}


int main(int argc, char **argv)
{
  ::testing::InitGoogleTest(&argc, argv);

  return RUN_ALL_TESTS();
}

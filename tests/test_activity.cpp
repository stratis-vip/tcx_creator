#include "gmock/gmock.h"
#include "activity.hpp"
#include "infostructure.hpp"
#include "options.hpp"

using namespace testing;

class TestCreateClass : public Test
{
public:

  void SetUp() override {
    ab.id = getCurrentDateTimeAsId(1527607906);
    ab.sport = "TESTING";
    ab.distance = 10000;
    ab.lapsEvery = 1000;
    tclass.loadInfo(ab);
  }
  
Activity tclass;
std::string idString = getCurrentDateTimeAsId(1527607906);
private:
  Info ab;
};

TEST_F(TestCreateClass, getSportType)
{
  ASSERT_THAT(tclass.getSportType(), StrEq("TESTING"));
}

TEST_F(TestCreateClass, getId)
{
  ASSERT_THAT(tclass.getId(), StrEq(idString));
}

TEST_F(TestCreateClass, ChangeSport)
{
  const char * sport = "Cycling";
  tclass.setSportType(sport);
  ASSERT_THAT(tclass.getSportType(), StrEq(sport));
}

int main(int argc, char **argv)
{
  ::testing::InitGoogleTest(&argc, argv);

  return RUN_ALL_TESTS();
}

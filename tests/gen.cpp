#include "gmock/gmock.h"
#include "testing.hpp"

using namespace testing;

class TestingEncoding : public Test
{
public:
  TestingClass tclass;
};

TEST_F(TestingEncoding, SimpeTest)
{
  ASSERT_THAT(2+2, Eq(4));
}

int main(int argc, char **argv)
{
  ::testing::InitGoogleTest(&argc, argv);

  return RUN_ALL_TESTS();
}

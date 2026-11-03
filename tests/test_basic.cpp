#include <gtest/gtest.h>

#include "add.h"

TEST(BasicAddition, AddsTwoInts) {
    EXPECT_EQ(add(2, 3), 5);
}

ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
    GTEST_DIR = c:/MinGW/include/gtest
	GMOCK_DIR = c:/MinGW/include/gmock
else
    GTEST_DIR = /usr/local/gtest
	GMOCK_DIR = /usr/local/gmock
endif

CC=g++
DEBUG = -ggdb 
CFLAGS_STANDARD = -std=gnu++11
CFLAGS_WARNING1 = -Wall
CFLAGS_WARNING2 = -Werror
CFLAGS_EXTRA = -m64

CFLAGS_NO_ERROR = $(CFLAGS_STANDARD) $(DEBUG) $(CFLAGS_EXTRA) 
CFLAGS = $(CFLAGS_NO_ERROR) $(CFLAGS_WARNING1) $(CFLAGS_WARNING2)
CFPRODUCTION=$(CFLAGS_STANDARD) $(CFLAGS_EXTRA) -O2

BOOST_LIBS = -lboost_filesystem -lboost_system #any other lib
INC = -Iinclude
TEST_INC = -I$(GTEST_DIR) -I$(GMOCK_DIR) -I$(GTEST_DIR)/include  -I$(GMOCK_DIR)/include 

OBJS_DIR = objs
BUILD_DIR = build
TESTS_DIR=$(BUILD_DIR)/tests
DIR_GUARD=@mkdir -p $(@D)
PROJECT = main

all: programs tests 

#  PROGRAMS
programs: $(BUILD_DIR)/$(PROJECT)

$(BUILD_DIR)/$(PROJECT): src/main.cpp #any other object files like objs/testing.o 
	$(DIR_GUARD)
	@echo -n compiling $@
	@$(CC) $(CFLAGS)  $^ $(INC) -o $@ 
	@echo " ...finished\n"

# OBJECTS

$(OBJS_DIR)/gtest.o: 
	$(DIR_GUARD)
	@echo -n compiling Google Test Library $@
	@$(CC) $(CFLAGS) -isystem -pthread -I$(GTEST_DIR)/include -I$(GTEST_DIR)  -c $(GTEST_DIR)/src/gtest-all.cc -o $@
	@echo " ...finished\n"

$(OBJS_DIR)/gmock.o: 
	$(DIR_GUARD)
	@echo -n compiling Google Mocking Library $@
	@$(CC) $(CFLAGS) -isystem -pthread -I$(TEST_INC) -c $(GMOCK_DIR)/src/gmock-all.cc -o $@
	@echo " ...finished\n"

$(OBJS_DIR)/testing.o: src/testing.cpp include/testing.hpp 
	$(DIR_GUARD)
	@echo -n compiling $@ 
	@$(CC) $(CFLAGS) -c src/testing.cpp -o $@ $(INC)
	@echo " ...finished\n"

# TESTS	

$(TESTS_DIR)/gen: objs/gmock.o objs/gtest.o objs/testing.o tests/gen.cpp
	$(DIR_GUARD)
	@echo -n compiling test $@ 
	@$(CC) $(CFPRODUCTION)  $^ -o $@ $(TEST_INC) $(INC) -Ipxml -Isrc
	@echo " ...finished\n"

tests: $(TESTS_DIR)/gen

clean:
	@rm -rf objs build

ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
    GTEST_DIR = c:/MinGW/include/gtest
	GMOCK_DIR = c:/MinGW/include/gmock
else
    GTEST_DIR = /usr/local/gtest
	GMOCK_DIR = /usr/local/gmock
endif

#curl support
#LDFLAGS=-L/usr/local/opt/curl/lib
#CPPFLAGS=-I/usr/local/opt/curl/include
CC=g++
DEBUG = -ggdb 
CFLAGS_STANDARD = -std=gnu++14
CFLAGS_WARNING1 = -Wall
CFLAGS_WARNING2 = -Werror
CFLAGS_EXTRA = -m64

CFLAGS_NO_ERROR = $(CFLAGS_STANDARD) $(DEBUG) $(CFLAGS_EXTRA) 
CFLAGS = $(CFLAGS_NO_ERROR) $(CFLAGS_WARNING1) $(CFLAGS_WARNING2)
CFPRODUCTION=$(CFLAGS_STANDARD) $(CFLAGS_EXTRA) -O2

BOOST_LIBS = -lboost_filesystem -lboost_system #any other lib
INC = -Iinclude -Ipxml
TEST_INC = -I$(GTEST_DIR) -I$(GMOCK_DIR) -I$(GTEST_DIR)/include  -I$(GMOCK_DIR)/include 

OBJS_DIR = objs
BUILD_DIR = build
TESTS_DIR=$(BUILD_DIR)/tests
DIR_GUARD=@mkdir -p $(@D)
PROJECT = main

all: programs tests 

#  PROGRAMS
programs: $(BUILD_DIR)/$(PROJECT)

$(BUILD_DIR)/$(PROJECT): src/main.cpp objs/pugixml.o objs/tcxobject.o #any other object files like objs/testing.o 
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

$(OBJS_DIR)/tcxobject.o: src/tcxobject.cpp include/tcxobject.hpp 
	$(DIR_GUARD)
	@echo -n compiling $@ 
	@$(CC) $(CFLAGS) -c src/tcxobject.cpp -o $@ $(INC)
	@echo " ...finished\n"

$(OBJS_DIR)/pugixml.o: pxml/pugixml.cpp 
	$(DIR_GUARD)
	@echo -n compiling $@ 
	@$(CC) $(CFLAGS) -c pxml/pugixml.cpp -o $@ $(INC)
	@echo " ...finished\n"



# TESTS	

$(TESTS_DIR)/gen: objs/gmock.o objs/gtest.o objs/pugixml.o tests/gen.cpp
	$(DIR_GUARD)
	@echo -n compiling test $@ 
	@$(CC) $(CFLAGS)  $^ -o $@ $(TEST_INC) $(INC) -Ipxml -Isrc
	@echo " ...finished\n"

tests: $(TESTS_DIR)/gen

clean:
	@rm -rf objs build

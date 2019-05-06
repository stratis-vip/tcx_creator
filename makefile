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

$(BUILD_DIR)/$(PROJECT): src/main.cpp objs/pugixml.o objs/tcxobject.o objs/options.o #any other object files like objs/testing.o 
	$(DIR_GUARD)
	@echo -n compiling $@
	@$(CC) $(CFLAGS)  $^ $(INC) -o $@ 
	@echo " ...finished\n"

# OBJECTS

$(OBJS_DIR)/gtest.o: 
	$(DIR_GUARD)
	@echo -n compiling Google Test Library $@
	@$(CC) $(CFLAGS) -I$(GTEST_DIR)/include -I$(GTEST_DIR)  -c $(GTEST_DIR)/src/gtest-all.cc -o $@ -isystem -lpthread 
	@echo " ...finished\n"

$(OBJS_DIR)/gmock.o: 
	$(DIR_GUARD)
	@echo -n compiling Google Mocking Library $@
	@$(CC) $(CFLAGS)  -I$(TEST_INC) -c $(GMOCK_DIR)/src/gmock-all.cc -o $@ -isystem -lpthread
	@echo " ...finished\n"

$(OBJS_DIR)/tcxobject.o: src/tcxobject.cpp include/tcxobject.hpp objs/activity.o objs/options.o
	$(DIR_GUARD)
	@echo -n compiling $@ 
	@$(CC) $(CFLAGS) -c src/tcxobject.cpp -o $@ $(INC)
	@echo " ...finished\n"

$(OBJS_DIR)/activity.o: src/activity.cpp include/activity.hpp objs/pugixml.o objs/options.o objs/options.o
	$(DIR_GUARD)
	@echo -n compiling $@ 
	@$(CC) $(CFLAGS) -c src/activity.cpp -o $@ $(INC)
	@echo " ...finished\n"

$(OBJS_DIR)/options.o: src/options.cpp include/options.hpp 
	$(DIR_GUARD)
	@echo -n compiling $@ 
	@$(CC) $(CFLAGS) -c src/options.cpp -o $@ $(INC)
	@echo " ...finished\n"

$(OBJS_DIR)/pugixml.o: pxml/pugixml.cpp 
	$(DIR_GUARD)
	@echo -n compiling $@ 
	@$(CC) $(CFLAGS) -c pxml/pugixml.cpp -o $@ $(INC)
	@echo " ...finished\n"

$(OBJS_DIR)/infostructure.o: src/infostructure.cpp include/infostructure.hpp
	$(DIR_GUARD)
	@echo -n compiling $@ 
	@$(CC) $(CFLAGS) -c src/infostructure.cpp -o $@ $(INC)
	@echo " ...finished\n"



# TESTS	

$(TESTS_DIR)/test_tcx_object: objs/gmock.o objs/gtest.o objs/pugixml.o \
tests/test_tcx_object.cpp objs/options.o
	$(DIR_GUARD)
	@echo -n compiling test $@ 
	@$(CC) $(CFLAGS) -isystem -pthread  $^ -o $@ $(TEST_INC) $(INC) -Ipxml -Isrc
	@echo " ...finished\n"

$(TESTS_DIR)/test_activity: objs/gtest.o objs/gmock.o objs/pugixml.o tests/test_activity.cpp \
objs/activity.o objs/infostructure.o objs/options.o
	$(DIR_GUARD)
	@echo -n compiling test $@ 
	@$(CC) $(CFLAGS)  -isystem -pthread  $^ -o $@ $(TEST_INC) $(INC) -Ipxml -Isrc
	@echo " ...finished\n"

tests: $(TESTS_DIR)/test_activity $(TESTS_DIR)/test_tcx_object

clean:
	@rm -rf objs build

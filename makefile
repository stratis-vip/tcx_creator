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
INC = -Iinclude -Ipxml -Isrc
TEST_INC = -isystem ${GTEST_DIR}/include -isystem ${GMOCK_DIR}/include -pthread 

OBJS_DIR = objs
BUILD_DIR = build
TESTS_DIR=$(BUILD_DIR)/tests
DIR_GUARD=@mkdir -p $(@D)
PROJECT = main

all: libs programs tests 

#  PROGRAMS
programs: $(BUILD_DIR)/$(PROJECT)

$(BUILD_DIR)/$(PROJECT): src/main.cpp ${OBJS_DIR}/pugixml.o ${OBJS_DIR}/libtcx.a #any other object files like ${OBJS_DIR}/testing.o 
	$(DIR_GUARD)
	@echo -n compiling $@
	@$(CC) $(CFLAGS)  $^ $(INC) -o $@ 
	@echo " ...finished\n"

# OBJECTS

$(OBJS_DIR)/gtest.o: 
	$(DIR_GUARD)
	@echo -n compiling Google Test Library $@
	@$(CC) $(CFLAGS) -isystem $(GTEST_DIR)/include -I$(GTEST_DIR)  -isystem $(GMOCK_DIR) \
	-pthread -c $(GTEST_DIR)/src/gtest-all.cc -o $@  
	@echo " ...finished\n"

$(OBJS_DIR)/gmock.o: 
	$(DIR_GUARD)
	@echo -n compiling Google Mocking Library $@
	@$(CC) $(CFLAGS) -isystem ${GTEST_DIR}/include -I${GTEST_DIR} \
    -isystem ${GMOCK_DIR}/include -I${GMOCK_DIR} \
    -pthread -c ${GMOCK_DIR}/src/gmock-all.cc -o $@ 
	@echo " ...finished\n"

$(OBJS_DIR)/tcxobject.o: src/tcxobject.cpp include/tcxobject.hpp ${OBJS_DIR}/activity.o ${OBJS_DIR}/options.o
	$(DIR_GUARD)
	@echo -n compiling $@ 
	@$(CC) $(CFLAGS) -c src/tcxobject.cpp -o $@ $(INC)
	@echo " ...finished\n"

$(OBJS_DIR)/activity.o: src/activity.cpp include/activity.hpp ${OBJS_DIR}/pugixml.o ${OBJS_DIR}/options.o ${OBJS_DIR}/options.o
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
	@$(CC) $(CFLAGS) $(INC) -c src/infostructure.cpp -o $@ 
	@echo " ...finished\n"

#LIBS


$(OBJS_DIR)/libgmock.a: ${OBJS_DIR}/gtest.o ${OBJS_DIR}/gmock.o
	@echo -n creating static Library $@
	@ar -rc $@ $^
	@echo " ...finished\n"

$(OBJS_DIR)/libtcx.a: ${OBJS_DIR}/infostructure.o ${OBJS_DIR}/options.o $(OBJS_DIR)/activity.o $(OBJS_DIR)/tcxobject.o
	@echo -n creating static Library $@
	@ar -rc $@ $^
	@echo " ...finished\n"

libs:$(OBJS_DIR)/libtcx.a $(OBJS_DIR)/libgmock.a

# TESTS	

$(TESTS_DIR)/test_tcx_object: ${OBJS_DIR}/libgmock.a ${OBJS_DIR}/pugixml.o \
tests/test_tcx_object.cpp ${OBJS_DIR}/libtcx.a
	$(DIR_GUARD)
	@echo -n compiling test $@ 
	@$(CC) $(CFLAGS) $(INC) $(TEST_INC) $^ ${OBJS_DIR}/libgmock.a -o $@  
	@echo " ...finished\n"

$(TESTS_DIR)/test_activity: ${OBJS_DIR}/libgmock.a ${OBJS_DIR}/pugixml.o tests/test_activity.cpp \
${OBJS_DIR}/libtcx.a
	$(DIR_GUARD)
	@echo -n compiling test $@ 
	@$(CC) $(CFLAGS) $(INC) $(TEST_INC) $^  ${OBJS_DIR}/libgmock.a -o $@
	@echo " ...finished\n"

tests: $(TESTS_DIR)/test_activity $(TESTS_DIR)/test_tcx_object

clean:
	@rm -rf objs build

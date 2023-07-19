#Copyright Dr. David A. Magezi (2023)
CXX = g++
CFLAGS = -O3 -std=c++20 -fmodules-ts
MODULE_LANGUAGE = -x c++
SYSTEM_HEADERS = fstream iostream sstream string string_view
SYSTEM_HEADER_CFLAGS = -x c++-system-header
UNIT_TEST_LIBRARY=boost_unit_test_framework
UNIT_TEST_DEFINE=-DBOOST_TEST_DYN_LINK


#EXTENSIONS
OBJ_EXT = .o
CPP_EXT =.cpp
MOD_EXT =$(CPP_EXT)m
IMP_EXT =_impl$(CPP_EXT)
MOD_CACHE_EXT =.gcm

#DIRECTORIES
BASE_DIR = ./
EXEC_DIR = $(BASE_DIR)bin
MOD_CACHE_DIR = $(BASE_DIR)gcm.cache
OBJ_DIR = $(BASE_DIR)objs
SRC_DIR = $(BASE_DIR)src
TEST_SUBFOLDER=tests
TEST_SRC_DIR = $(SRC_DIR)/$(TEST_SUBFOLDER)
UNIT_TEST_SRC_DIR = $(TEST_SRC_DIR)/unit_tests

TARGET_STEM = csv_to_database
TARGET = $(EXEC_DIR)/$(TARGET_STEM)

SYSTEM_CACHE_DIR = $(MOD_CACHE_DIR)/usr/include/c++/13.1.1
_SYSTEM_CACHE_ITEMS = $(addsuffix $(MOD_CACHE_EXT), $(SYSTEM_HEADERS))
SYSTEM_CACHE_ITEMS = $(addprefix $(SYSTEM_CACHE_DIR)/, $(_SYSTEM_CACHE_ITEMS))

_RFC = read_from_csv
_RFC_DEPS_STEMS = read
_RFC_MODS = $(addsuffix $(MOD_EXT), $(_RFC_DEPS_STEMS))
_RFC_IMPS = $(addsuffix $(IMP_EXT), $(_RFC_DEPS_STEMS))

RFC_OBJ_DIR = $(OBJ_DIR)/$(_RFC)
RFC_SRC_DIR = $(SRC_DIR)/$(_RFC)
RFC_MODS = $(addprefix $(RFC_SRC_DIR)/, $(_RFC_MODS))
RFC_IMPS = $(addprefix $(RFC_SRC_DIR)/, $(_RFC_IMPS))
_RFC_MOD_OBJS = $(_RFC_MODS:$(MOD_EXT)=$(OBJ_EXT)) 
RFC_MOD_OBJS = $(addprefix $(RFC_OBJ_DIR)/, $(_RFC_MOD_OBJS))
_RFC_IMP_OBJS = $(_RFC_IMPS:$(CPP_EXT)=$(OBJ_EXT)) 
RFC_IMP_OBJS = $(addprefix $(RFC_OBJ_DIR)/, $(_RFC_IMP_OBJS))

TEST_PREFIX = test_

UNIT_TEST_RFC_SRC_DIR = $(UNIT_TEST_SRC_DIR)/$(_RFC)
_UNIT_TEST_RFC_SRC = $(_RFC_MODS:$(MOD_EXT)=$(CPP_EXT)) 
UNIT_TEST_RFC_SRC = $(addprefix $(UNIT_TEST_RFC_SRC_DIR)/$(TEST_PREFIX), $(_UNIT_TEST_RFC_SRC))

TEST_TARGET_STEM = test_all
UNIT_TEST_TARGET = $(EXEC_DIR)/unit_$(TEST_TARGET_STEM)

all: $(TARGET) $(UNIT_TEST_TARGET)

$(EXEC_DIR):
	mkdir -p $@

$(RFC_OBJ_DIR):
	mkdir -p $@

$(SYSTEM_CACHE_ITEMS): $(SYSTEM_HEADER) 
	for i in $(SYSTEM_HEADERS); do \
		$(CXX)  $(CFLAGS) $(SYSTEM_HEADER_CFLAGS) $$i; \
	done 

$(RFC_MOD_OBJS): $(RFC_OBJ_DIR)/%$(OBJ_EXT): $(RFC_MODS) $(SYSTEM_CACHE_ITEMS) | $(RFC_OBJ_DIR)
	$(CXX)  $(MODULE_LANGUAGE) $< -c -o $@  $(CFLAGS)

$(RFC_IMP_OBJS): $(RFC_OBJ_DIR)/%$(OBJ_EXT): $(RFC_IMPS) $(RFC_MOD_OBJS) 
	$(CXX)  $< -c -o $@  $(CFLAGS) -I$(SRC_DIR)

$(TARGET): $(SRC_DIR)/$(TARGET_STEM)$(CPP_EXT) $(RFC_MOD_OBJS) $(RFC_IMP_OBJS) $(SYSTEM_CACHE_ITEMS) | $(EXEC_DIR)
	@echo "(Compiling and) Linking $(TARGET) ..."
	$(CXX) $< -o $@ $(RFC_MOD_OBJS) $(RFC_IMP_OBJS) $(CFLAGS)

$(UNIT_TEST_TARGET): $(UNIT_TEST_SRC_DIR)/$(TEST_TARGET_STEM)$(CPP_EXT) $(UNIT_TEST_RFC_SRC) $(SYSTEM_CACHE_ITEMS) $(RFC_MOD_OBJS) $(RFC_IMP_OBJS) | $(EXEC_DIR)
	@echo "(Compiling and) Linking $(UNIT_TEST_TARGET) ..."
	$(CXX) $< -o $@ $(UNIT_TEST_RFC_SRC) $(RFC_MOD_OBJS) $(RFC_IMP_OBJS) $(CFLAGS) -l$(UNIT_TEST_LIBRARY) $(UNIT_TEST_DEFINE)

clean:
	rm $(SYSTEM_CACHE_ITEMS) $(TARGET) $(UNIT_TEST_TARGET) $(RFC_MOD_OBJS) $(RFC_IMP_OBJS)
	rmdir $(EXEC_DIR) $(RFC_OBJ_DIR)  $(OBJ_DIR)


run:
	$(TARGET)

test:
	$(UNIT_TEST_TARGET)


comments:
	$(BASE_DIR)add_copyright_and_document_comments.sh

peak: 
	@echo "unit test source files are $(SYSTEM_CACHE_ITEMS)"



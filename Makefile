ifeq ($(and $(strip $(DEVKITPRO)),$(strip $(DEVKITARM))),)
$(error Make sure DEVKITPRO and DEVKITARM are correctly set in your environment.)
endif

# Tools
ifeq ($(OS),Windows_NT)
  EXE := .exe
else
  EXE :=
endif

# Name of your ROM
PROJECT		:= gba-template

# Set to '1' if debug
DEBUG = 1

# DEF_FLAGS
DEF_FLAGS = -DDEBUG=$(DEBUG)

# Uncomment this if you're building a library
#
# BUILD_LIB	:= yes

# Options for gbafix (optional)
#
# Title:        12 characters
# Game code:     4 characters
# Maker code:    2 characters
# Version:       1 character
ROM_TITLE	:= UNTITLED RPG
ROM_GAMECODE	:= TR1E
ROM_MAKERCODE	:= TM
ROM_VERSION	:= 1

#
# Files
#
# Options ending in _FILES list individual files
# Options ending in _DIRS and _EXTS are used for globbing
#
# For every directory listed in a _DIRS option, every file with an extension
# listed in the matching _EXTS option is collected
#
# This process is not recursive, so if you have nested directories, you will
# have to list all of them
#
# If you want to get every .c and .cpp file in a directory called source:
#
# SOURCE_DIRS := source
# SOURCE_EXTS := c cpp

# Binary files to process with bin2s
BINARY_FILES:=
BINARY_DIRS	:=
BINARY_EXTS	:=

# Music Src Files
include sound/out/Soundfiles
SOUND_DIR  := sound/src/

# Graphics files to process with grit
#
# Every file requires an accompanying .grit file,
# so gfx/test.png needs gfx/test.png.grit
GRAPHICS_FILES	:=
GRAPHICS_DIRS	:=
GRAPHICS_EXTS	:= png pal

# Source files to compile
SOURCE_FILES    :=  $(SOUND_FILES)
SOURCE_DIRS		:= source data/maps source/wave graphics/text
SOURCE_EXTS		:= c s

# Include directories
INCLUDES		:= include include/gba asm asm/macros

# Library directories, with /include and /lib
LIBDIRS		:= $(DEVKITPRO)/libgba $(DEVKITPRO)/libtonc

# Libraries to link
LIBS		:= tonc

# All build output goes here
BUILDDIR	:= build

# Compiler flags (all languages)
ALLFLAGS	:= -Wextra -g3 -gdwarf-4 -O2 \
		-ffunction-sections -fdata-sections \
		-D_DEFAULT_SOURCE
		
# Architecture
ARCH	:=	-mthumb -mthumb-interwork

# C compiler flags
ifeq ($(DEBUG),1)
	CFLAGS := $(DEF_FLAGS) -gdwarf-2 -mcpu=arm7tdmi -mtune=arm7tdmi\
			-Wno-pointer-to-int-cast \
			$(ARCH)
else
	CFLAGS	:= $(DEF_FLAGS) -g -O2 -mcpu=arm7tdmi -mtune=arm7tdmi\
			-Wno-pointer-to-int-cast \
			$(ARCH)
endif

# C++ compiler flags
CXXFLAGS	:= $(DEF_FLAGS) -std=c++20 -fno-rtti -fno-exceptions

# Assembler flags (as passed to GCC)
ASFLAGS		:= -g $(ARCH) -trigraphs\
		-mcpu=arm7tdmi

# Linker flags (as passed to GCC)
LDFLAGS		:= -mthumb \
		$(if $(filter %_mb,$(PROJECT)),-specs=gba_mb.specs,-specs=tony.specs)

# Uncomment this if you want to use Link Time Optimization
#
# USE_LTO		:= yes

include build.mk

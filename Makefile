#---------------------------------------------------------------------------------
# Clear the implicit built in rules
#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(PSL1GHT)),)
$(error "Please set PSL1GHT in your environment. export PSL1GHT=<path>")
endif

include	$(PSL1GHT)/ppu_rules

#---------------------------------------------------------------------------------
ifeq ($(strip $(PLATFORM)),)
#---------------------------------------------------------------------------------
export BASEDIR		:= $(CURDIR)
export DEPS			:= $(BASEDIR)/deps
export LIBS			:= $(BASEDIR)/lib
#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
export LIBDIR		:= $(LIBS)/$(PLATFORM)
export DEPSDIR		:= $(DEPS)/$(PLATFORM)
#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------

TARGET		   			   :=  libbitconverter
TARGET_A       			   :=  $(TARGET).a
TARGET_O       			   :=  $(TARGET).o

BUILD		   			   :=  build
BUILD_PS3      			   :=  $(BUILD)/PS3
BUILD_PC       			   :=  $(BUILD)/PC
BUILD_TARGET_O 			   :=  $(BUILD)/$(TARGET_O)
BUILD_WHATEVER 			   :=  $(BUILD)/*.*

SOURCE		   			   :=  src
INCLUDE		   			   :=  $(SOURCE)/include
LIBS		   			   :=  dbglogger
PCFLAGS                    :=  -O3 -Wall -Wextra -Werror -std=gnu17
CFLAGS		               +=  -O3 -Wall -Wextra -Werror -mcpu=cell -mtune=cell -mgen-cell-microcode -mbig-endian -std=gnu11 -DPOWERPC64_PS3_ELF $(INCLUDES) # -mpowerpc64
LD			               :=  ppu-ld
USR_INCLUDE_BIT_CONVERTER  :=  usr/include/bitconverter
USR_LIB_BIT_CONVERTER      :=  usr/lib/bitconverter

ifneq ($(BUILD),$(notdir $(CURDIR)))

export OUTPUT	:=	$(CURDIR)/$(TARGET)
export VPATH	:=	$(foreach dir,$(SOURCE),$(CURDIR)/$(dir)) \
					$(foreach dir,$(DATA),$(CURDIR)/$(dir))
export BUILDDIR	:=	$(CURDIR)/$(BUILD)
export DEPSDIR	:=	$(BUILDDIR)

CFILES		:= $(foreach dir,$(SOURCE),$(notdir $(wildcard $(dir)/*.c)))
CXXFILES	:= $(foreach dir,$(SOURCE),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES		:= $(foreach dir,$(SOURCE),$(notdir $(wildcard $(dir)/*.S)))
BINFILES	:= $(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.bin)))
VCGFILES	:= $(foreach dir,$(SOURCE),$(notdir $(wildcard $(dir)/*.vcg)))
VSAFILES	:= $(foreach dir,$(SOURCE),$(notdir $(wildcard $(dir)/*.vsa)))

export OFILES	:=	$(CFILES:.c=.o) \
					$(CXXFILES:.cpp=.o) \
					$(SFILES:.S=.o) \
					$(BINFILES:.bin=.bin.o) \
					$(VCGFILES:.vcg=.vcg.o) \
					$(VSAFILES:.vsa=.vsa.o)
export BINFILES	:=	$(BINFILES:.bin=.bin.h)
export VCGFILES	:=	$(VCGFILES:.vcg=.vcg.h)
export VSAFILES	:=	$(VSAFILES:.vsa=.vsa.h)
export INCLUDES	=	$(foreach dir,$(INCLUDE),-I$(CURDIR)/$(dir)) -I$(CURDIR)/$(BUILD) -I$(PSL1GHT)/ppu/include -I$(PORTLIBS)/include

.PHONY: $(BUILD) clean

ps3:
	@[ -d $(BUILD) ] || mkdir -p $(BUILD)
	@make --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile
	@[ -d $(BUILD_PS3) ] || mkdir -p $(BUILD_PS3)
	@mv $(TARGET_A) $(BUILD_PS3)
	@mv $(BUILD_WHATEVER) $(BUILD_PS3)

clean:
	@echo "Clean..."
	@rm -rf $(BUILD)/
	@echo "Clean :)"

pc:
	@[ -d $(BUILD) ] || mkdir -p $(BUILD)
	@gcc -c $(SOURCE)/*.c $(PCFLAGS) -I$(INCLUDE) -o $(BUILD_TARGET_O)
	@ar -rc $(TARGET_A) $(BUILD_TARGET_O)
	@[ -d $(BUILD_PC) ] || mkdir -p $(BUILD_PC)
	@mv $(TARGET_A) $(BUILD_PC)
	@mv $(BUILD_WHATEVER) $(BUILD_PC)

install-ps3:
	@echo "Copying..."
	@cp $(INCLUDE)/bitconverter.h $(PORTLIBS)/include
	@cp $(BUILD_PS3)/libbitconverter.a $(PORTLIBS)/lib
	@echo "Copied!"

install-pc:
	@echo "Copying..."
	@mkdir -p $(USR_INCLUDE_BIT_CONVERTER)
	@cp $(INCLUDE)/bitconverter.h $(USR_INCLUDE_BIT_CONVERTER)
	@mkdir -p $(USR_LIB_BIT_CONVERTER)
	@cp $(BUILD_PC)/libbitconverter.a $(USR_LIB_BIT_CONVERTER)
	@echo "Copied!"

else

DEPENDS	:= $(OFILES:.o=.d)

$(OUTPUT).a: $(OFILES)
$(OFILES): $(BINFILES) $(VCGFILES) $(VSAFILES)

-include $(DEPENDS)

endif

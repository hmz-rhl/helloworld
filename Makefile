top_builddir=$(PWD)

DESTDIR ?=
$(info "DESTDIR=$(DESTDIR)")

CROSS_COMPILE ?=
$(info "CROSS_COMPILE=$(CROSS_COMPILE)")

ARCH = aarch64
$(info "ARCH=$(ARCH)")

CC=$(CROSS_COMPILE)gcc
LD=${CROSS_COMPILE}ld
AR=${CROSS_COMPILE}ar

# PATHS
SRCDIR	= .
SRCS	= $(SRCDIR)/helloworld.c
BINNAME = helloworld

BINDIR	= bin


# FLAGS
CFLAGS = -Wall
#CFLAGS += -g -O0   # Enable for Debugging
CFLAGS += -I$(top_builddir)/include
CFLAGS += -I$(top_builddir)/src
CFLAGS += -I$(top_builddir)/src/vfio
CFLAGS += -I$(top_builddir)/flib/mc

#Flags passed on make command line
CFLAGS += $(CMDFLAGS)

# TARGETS
EXECS	= $(SRCS:%.c=%)
OBJS	= $(SRCS:%.c=%.o)
DEPS	= $(SRCS:%.c=%.d)

LFLAGS	+= $(VFIODIR)/libvfio.a
LFLAGS	+= $(MCDIR)/libmcflib.a

# RULES
all: $(BINNAME)

execs:   $(EXECS)

#mcflib:
#	$(MAKE) -C $(MCDIR) all

$(BINNAME): $(OBJS) #mcflib vfio
	@mkdir -p $(BINDIR)
	$(CC) -o $(BINDIR)/$@ $(CFLAGS) $(OBJS) $(LFLAGS)

install: all
	@mkdir -p $(DESTDIR)/usr/bin
	cp -ar $(BINDIR)/$(BINNAME) $(DESTDIR)/usr/bin/

.PHONY: $(BINNAME) install clean #vfio mcflib 

clean:
	rm -rf $(EXECS) $(OBJS) $(DEPS) $(BINDIR) *.d *.a
	#@for subdir in $(VFIODIR) $(MCDIR); do \
	 #    $(MAKE) -C $$subdir clean; \
	#done

#LOCAL_CFLAGS ?= -Wall -g
#PROGRAM = helloworld

#$(PROGRAM): $(PROGRAM).c
#	$(CC) $(CFLAGS) $(LOCAL_CFLAGS) $(LDFLAGS) $^ -o $@
#install:
#  cp $(PROGRAM) ../../../../build/rfs/rootfs_lsdk2108_ubuntu_main_arm64/bin
#clean:
#	rm -f $(PROGRAM)

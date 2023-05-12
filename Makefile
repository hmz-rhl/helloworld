LOCAL_CFLAGS ?= -Wall -g
PROGRAM = helloworld

$(PROGRAM): $(PROGRAM).c
	$(CC) $(CFLAGS) $(LOCAL_CFLAGS) $(LDFLAGS) $^ -o $@
install:
  cp $(PROGRAM) ../../../../build/rfs/rootfs_lsdk2108_ubuntu_main_arm64/bin
clean:
	rm -f $(PROGRAM)

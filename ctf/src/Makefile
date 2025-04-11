CANARY := -fstack-protector
NOCANARY := -fno-stack-protector

X86 := -m32
X64 := -m64

NOPIE := -no-pie -fno-pie
PIE := -pie -fpie

CFLAGS := -g -O0
# Select the options you want from above
CFLAGS += $(X86) $(CANARY) $(NOPIE)

ALL := target

all: $(ALL)

target:
	$(CC) $(CFLAGS) target.c -o target

clean:
	rm -rf $(ALL)

.PHONY: all clean

ZEPHYR_SDK_VERSION:=0.17.0
ARCH:=$(shell uname -m)
ifeq ($(ARCH),arm64)
	ARCH=aarch64
endif
PLATFORM:=$(shell uname)
ifeq ($(PLATFORM),Darwin)
	OS = macos
else ifeq ($(PLATFORM),Linux)
	OS = linux
else
	OS = unknown
endif
ZEPHYR_SDK:=zephyr-sdk-$(ZEPHYR_SDK_VERSION)
ZEPHYR_SDK_ARCHIVE:=$(ZEPHYR_SDK)_$(OS)-$(ARCH).tar.xz

default: build

$(ZEPHYR_SDK_ARCHIVE):
	wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v$(ZEPHYR_SDK_VERSION)/$(ZEPHYR_SDK_ARCHIVE)

$(ZEPHYR_SDK): $(ZEPHYR_SDK_ARCHIVE)
	wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v$(ZEPHYR_SDK_VERSION)/sha256.sum | shasum --check --ignore-missing
	tar xvf $(ZEPHYR_SDK_ARCHIVE)

$(ZEPHYR_SDK)/.installed: $(ZEPHYR_SDK)
	cd $<; ./setup.sh && touch .installed

.west:
	west init -l config
	west update
	west zephyr-export

build_totem_dongle/zephyr/zmk.uf2: .west config
	west build -s zmk/app -b seeeduino_xiao_ble -p always -d build_totem_dongle -- -DZMK_CONFIG=$(CURDIR)/config -DSHIELD=totem_dongle

.PHONY:
install: $(ZEPHYR_SDK)/.installed

.PHONY:
build: build_totem_dongle/zephyr/zmk.uf2
	cp $< totem_dongle.uf2

KCONFIG_DIR = ./kconfig

srctree := $(shell test -d kconfig && pwd)
export LiRE_DIR=$(srctree)

export build_alias := $(shell $(srctree)/scripts/config.guess)
override ARCH := $(shell echo $(build_alias)|cut -f1 -d-|sed -e s/^i.86/i386/ -e s/^powerpc/ppc/)

ifeq ($(MAKECMDGOALS),)
confgui = $(shell test $(TERM) = emacs && echo xconfig || echo menuconfig)
forceconf = $(shell test -r .lire_config || echo $(confgui))
endif

.lire_config:: $(forceconf)
	@/bin/true

all install: .lire_config
	@$(LiRE_DIR)/scripts/install/lire_install

update: .lire_config
	@$(LiRE_DIR)/scripts/update/lire_update

build: .lire_config
	@ARCH=$(ARCH) $(LiRE_DIR)/scripts/build/lire_build


xconfig: qconf

gconfig: gconf

mconfig  menuconfig: mconf
	

config: conf

oldconfig: oldconf

reconfig::
	@touch .lire_config

lire-install: .lire_config
	@$(LiRE_DIR)/scripts/install/lire_install


qconf: $(KCONFIG_DIR)
	@$(MAKE) -C $(KCONFIG_DIR) \
	-f $(srctree)/$(KCONFIG_DIR)/Makefile.kconfig xconfig \
	srctree=$(srctree) ARCH=$(ARCH)

gconf: $(KCONFIG_DIR)
	@$(MAKE) -C $(KCONFIG_DIR) \
	-f $(srctree)/$(KCONFIG_DIR)/Makefile.kconfig gconfig \
	srctree=$(srctree) ARCH=$(ARCH)

mconf: $(KCONFIG_DIR)
	@$(MAKE) -C $(KCONFIG_DIR) \
	-f $(srctree)/$(KCONFIG_DIR)/Makefile.kconfig menuconfig \
	srctree=$(srctree) ARCH=$(ARCH)
	@$(LiRE_DIR)/scripts/prepare/lire_prepare

conf: $(KCONFIG_DIR)
	@$(MAKE) -C $(KCONFIG_DIR) \
	-f $(srctree)/$(KCONFIG_DIR)/Makefile.kconfig config \
	srctree=$(srctree) ARCH=$(ARCH)

oldconf: $(KCONFIG_DIR)
	@$(MAKE) -C $(KCONFIG_DIR) \
	-f $(srctree)/$(KCONFIG_DIR)/Makefile.kconfig oldconfig \
	srctree=$(srctree) ARCH=$(ARCH)
	@$(LiRE_DIR)/scripts/prepare/lire_prepare

$(KCONFIG_DIR):
	@test -d $@ || mkdir -p $@

help:
	@echo ; echo "This is LiRE's build bootstrapping Makefile. In order to build LiRE," ; \
	echo 'you first need to configure it. Proceed as follows:' ; \
	echo ; echo '$$ cd $$your_builddir' ; echo ; \
	echo '# Configuration using a KDE-based, GTK-based or Dialog-based GUI' ; \
	echo '$$ make -f $$lire_srcdir/makefile srctree=$$lire_srcdir {xconfig,gconfig,menuconfig}' ; \
	echo '                            OR,' ; \
	echo '# Configuration using a text-based interface' ; \
	echo '$$ make -f $$lire_srcdir/makefile srctree=$$lire_srcdir {config,oldconfig}' ; \
	echo ; echo 'In case a configuration error occurs, re-run the command above to fix the' ; \
	echo 'faulty parameter. Once the configuration is successful, type:' ; echo ; \
	echo '$$ make [update]' ; \
	echo '$$ make [build]'; \
	echo '$$ make [all]'; \
	echo ; echo "To change the configuration from now on, simply run:"; echo ; \
	echo '$$ make {xconfig,gconfig,menuconfig,config}' ; echo

clean distclean:
	@$(LiRE_DIR)/scripts/clean/lire_clean
	if test -r $(KCONFIG_DIR)/Makefile.kconfig ; then \
	    $(MAKE) -C $(KCONFIG_DIR) -f Makefile.kconfig clean ; \
	fi
	rm -rf $(KCONFIG_DIR)/.config.cmd $(KCONFIG_DIR)/.tmpconfig.h
	if test -r GNUmakefile ; then \
	    $(MAKE) -f GNUmakefile $@ ; \
	else \
	    $(MAKE) -C $(KCONFIG_DIR) -f $(srctree)/$(KCONFIG_DIR)/Makefile.kconfig clean ; \
	fi
	@find . -name autom4te.cache | xargs rm -fr

packageclean:
	@$(LiRE_DIR)/scripts/clean/lire_package_clean

release:
	@$(LiRE_DIR)/scripts/clean/lire_release_clean

.PHONY: config-script reconfig xconfig gconfig mconfig menuconfig config oldconfig qconf mconf conf clean distclean packageclean release help

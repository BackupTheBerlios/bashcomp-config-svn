# $Id$

bin_SCRIPTS = bash-completion-config
man_MANS = bash-completion-config.1

CLEANFILES = bash-completion-config \
	     bash-completion-config.1 \
	     completion

MAINTAINERCLEANFILES = aclocal.m4 \
		       configure \
		       Makefile.in
		       config/config.guess \
		       config/ltmain.sh \
		       config/config.sub
		       
EXTRA_DIST = autogen.sh \
	     bash-completion-config.in \
	     bash-completion-config.1.in \
	     completion.in

all: bash-completion-config bash-completion-config.1 completion

# have to use %VAR% here instead of @VAR@ or it will attempt
# to expand the variable

bash-completion-config: bash-completion-config.in
	@echo " * building bash-completion-config"
	@@SED@ -e "s,%BASH%,$(BASH)," \
	      -e "s,%PACKAGE%,$(PACKAGE)," \
	      -e "s,%VERSION%,$(VERSION)," \
	      -e "s,%DATADIR%,$(datadir)," \
	      -e "s,%SYSCONFDIR%,$(sysconfdir)," \
	      bash-completion-config.in > bash-completion-config
	@chmod +x bash-completion-config

bash-completion-config.1: bash-completion-config.1.in
	@echo " * building bash-completion-config.1"
	@@SED@ -e "s,%PACKAGE%,$(PACKAGE)," \
	      -e "s,%VERSION%,$(VERSION)," \
	      -e "s,%DATADIR%,$(datadir)," \
	      -e "s,%SYSCONFDIR%,$(sysconfdir)," \
	      bash-completion-config.1.in > bash-completion-config.1

completion: completion.in
	@echo " * building completion"
	@@SED@ -e "s,%PACKAGE%,$(PACKAGE)," \
	       -e "s,%DATADIR%,$(datadir)," \
	       -e "s,%SYSCONFDIR%,$(sysconfdir)," \
	       completion.in > completion

install-data-local: completion
	$(mkinstalldirs) $(DESTDIR)$(datadir)/bash-completion
	$(INSTALL_DATA) completion \
		$(DESTDIR)$(datadir)/bash-completion/bash-completion-config

# $Id$

AUTOMAKE_OPTIONS = foreign

bin_SCRIPTS = bash-completion-config
man_MANS = bash-completion-config.1
noinst_DATA = completion

CLEANFILES = $(bin_SCRIPTS) \
	     $(man_MANS) \
	     $(noinst_DATA)

MAINTAINERCLEANFILES = aclocal.m4 \
		       configure \
		       Makefile.in \
		       config/config.guess \
		       config/ltmain.sh \
		       config/config.sub
		       
EXTRA_DIST = $(bin_SCRIPTS:%=%.in) \
	     $(man_MANS:%=%.in) \
	     $(noinst_DATA:%=%.in) \
	     autogen.sh \
	     functions.sh \
	     config/

# have to use %VAR% here instead of @VAR@ or it will attempt
# to expand the variable
dosed = @SED@ -e "s,%BASH%,$(BASH),g" \
	      -e "s,%FUNCTIONS_SH%,$(FUNCTIONS_SH),g" \
	      -e "s,%PACKAGE%,$(PACKAGE),g" \
	      -e "s,%VERSION%,$(VERSION),g" \
	      -e "s,%DATADIR%,$(datadir),g" \
	      -e "s,%SYSCONFDIR%,$(sysconfdir),g" 

%: %.in
	@echo " * building $@"
	@$(dosed) $< > $@
	@if test $@ = $(bin_SCRIPTS); then chmod +x $@; fi
	

install-data-local: completion
	$(mkinstalldirs) $(DESTDIR)$(datadir)/bash-completion
	$(INSTALL_DATA) completion \
		$(DESTDIR)$(datadir)/bash-completion/bash-completion-config
	if test ! -e /sbin/functions.sh ; then \
		$(mkinstalldirs) $(DESTDIR)$(datadir)/$(PACKAGE); \
		$(INSTALL_DATA) functions.sh $(DESTDIR)$(datadir)/$(PACKAGE); \
	fi
		

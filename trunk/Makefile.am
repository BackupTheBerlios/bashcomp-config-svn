# $Id$

AUTOMAKE_OPTIONS = foreign dist-bzip2

bin_SCRIPTS = bash-completion-config
man_MANS = bash-completion-config.1
noinst_DATA = completion
noinst_SCRIPTS = profile.d

CLEANFILES = $(bin_SCRIPTS) \
	     $(man_MANS) \
	     $(noinst_DATA) \
	     $(noinst_SCRIPTS)

MAINTAINERCLEANFILES = aclocal.m4 \
		       configure \
		       Makefile.in \
		       config/config.guess \
		       config/ltmain.sh \
		       config/config.sub

EXTRA_DIST = $(bin_SCRIPTS:%=%.in) \
	     $(man_MANS:%=%.in) \
	     $(noinst_DATA:%=%.in) \
	     $(noinst_SCRIPTS:%=%.in) \
	     autogen.sh \
	     functions.sh

# have to use %VAR% here instead of @VAR@ or it will attempt
# to expand the variable
dosed = @SED@ -e "s,%BASH%,$(BASH),g" \
	      -e "s,%FUNCTIONS_SH%,$(FUNCTIONS_SH),g" \
	      -e "s,%PACKAGE%,@PACKAGE_NAME@,g" \
	      -e "s,%VERSION%,@PACKAGE_VERSION@,g" \
	      -e "s,%DATADIR%,$(datadir),g" \
	      -e "s,%SYSCONFDIR%,$(sysconfdir),g" 

%: %.in
	@echo " * building $@"
	@$(dosed) $< > $@
	@if test $@ = $(bin_SCRIPTS); then chmod +x $@; fi

# automatically add month & year to manual page(s) when running 'make dist'
dist-hook:
	@SED@ -ie "s/\"[a-zA-Z]\{3\} [0-9]\{4\}\"/\"`date '+%b %Y'`\"/" \
		$(distdir)/$(man_MANS:%=%.in)
		
install-exec-local:
	if test ! -e $(DESTDIR)$(sysconfdir)/profile.d/bash-completion ; then \
		$(mkinstalldirs) $(DESTDIR)$(sysconfdir)/profile.d; \
		$(INSTALL) profile.d \
			$(DESTDIR)$(sysconfdir)/profile.d/bash-completion; \
	fi

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(datadir)/bash-completion
	$(INSTALL_DATA) completion \
		$(DESTDIR)$(datadir)/bash-completion/@PACKAGE_NAME@
	if test ! -e $(DESTDIR)/sbin/functions.sh ; then \
		$(mkinstalldirs) $(DESTDIR)$(datadir)/@PACKAGE_NAME@; \
		$(INSTALL_DATA) functions.sh \
			$(DESTDIR)$(datadir)/@PACKAGE_NAME@; \
	fi

uninstall-local:
	rm -f $(DESTDIR)$(datadir)/bash-completion/@PACKAGE_NAME@
	rmdir $(DESTDIR)$(datadir)/bash-completion
	rm -f $(DESTDIR)$(sysconfdir)/profile.d/bash-completion
	rmdir $(DESTDIR)$(sysconfdir)/profile.d
	if test -e $(datadir)/@PACKAGE_NAME@/functions.sh ; then \
		rm -f $(DESTDIR)$(datadir)/@PACKAGE_NAME@/functions.sh; \
		rmdir $(DESTDIR)$(datadir)/@PACKAGE_NAME@; \
	fi


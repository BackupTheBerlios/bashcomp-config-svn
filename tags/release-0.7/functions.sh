# NOTE: this is a minimal version of functions.sh distributed with 
# Gentoo's baselayout package.  It is included for use by non-Gentoo
# operating systems and will be installed as 
# $(DESTDIR)($datadir)/bash-completion-config/functions.sh

# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-src/rc-scripts/sbin/functions.sh,v 1.55 2004/08/18 20:35:37 agriffis Exp $

# void einfo(char* message)
#
#    show an informative message (with a newline)
#
einfo() {
	echo -e " ${GOOD}*${NORMAL} ${*}"
	return 0
}

# void einfon(char* message)
#
#    show an informative message (without a newline)
#
einfon() {
	echo -ne " ${GOOD}*${NORMAL} ${*}"
	return 0
}

# void ewarn(char* message)
#
#    show a warning message + log it
#
ewarn() {
	echo -e " ${WARN}*${NORMAL} ${*}"
	return 0
}

# void eerror(char* message)
#
#    show an error message + log it
#
eerror() {
	echo -e " ${BAD}*${NORMAL} ${*}"
	return 0
}

# void ebegin(char* message)
#
#    show a message indicating the start of a process
#
ebegin() {
	echo -e " ${GOOD}*${NORMAL} ${*}..."
	return 0
}

# void eend(int error, char* errstr)
#
#    indicate the completion of process
#    if error, show errstr via eerror
#
eend() {
	local retval=
	
	if [ "$#" -eq 0 ] || ([ -n "$1" ] && [ "$1" -eq 0 ])
	then
		echo -e "${ENDCOL}  ${BRACKET}[ ${GOOD}ok${BRACKET} ]${NORMAL}"
	else
		retval="$1"
		
		if [ -c /dev/null ] ; then
			rc_splash "stop" &>/dev/null &
		else
			rc_splash "stop" &
		fi
		
		if [ "$#" -ge 2 ]
		then
			shift
			eerror "${*}"
		fi

		echo -e "${ENDCOL}  ${BRACKET}[ ${BAD}!!${BRACKET} ]${NORMAL}"
		# extra spacing makes it easier to read
		echo

		return ${retval}
	fi

	return 0
}

# void ewend(int error, char *warnstr)
#
#    indicate the completion of process
#    if error, show warnstr via ewarn
#
ewend() {
	local retval=
	
	if [ "$#" -eq 0 ] || ([ -n "$1" ] && [ "$1" -eq 0 ])
	then
		echo -e "${ENDCOL}  ${BRACKET}[ ${GOOD}ok${BRACKET} ]${NORMAL}"
	else
		retval="$1"
		if [ "$#" -ge 2 ]
		then
			shift
			ewarn "${*}"
		fi
		
		echo -e "${ENDCOL}  ${BRACKET}[ ${WARN}!!${BRACKET} ]${NORMAL}"
		# extra spacing makes it easier to read
		echo
		return "${retval}"
	fi

	return 0
}

# Safer way to list the contents of a directory,
# as it do not have the "empty dir bug".
#
# char *dolisting(param)
#
#    print a list of the directory contents
#
#    NOTE: quote the params if they contain globs.
#          also, error checking is not that extensive ...
#
dolisting() {
	local x=
	local y=
	local tmpstr=
	local mylist=
	local mypath="${*}"

	if [ "${mypath%/\*}" != "${mypath}" ]
	then
		mypath="${mypath%/\*}"
	fi
	
	for x in ${mypath}
	do
		[ ! -e "${x}" ] && continue
		
		if [ ! -d "${x}" ] && ( [ -L "${x}" -o -f "${x}" ] )
		then
			mylist="${mylist} $(ls "${x}" 2> /dev/null)"
		else
			[ "${x%/}" != "${x}" ] && x="${x%/}"
			
			cd "${x}"; tmpstr="$(ls)"
			
			for y in ${tmpstr}
			do
				mylist="${mylist} ${x}/${y}"
			done
		fi
	done
	
	echo "${mylist}"
}

getcols() {
	echo "$2"
}

if [ -z "${EBUILD}" ]
then
	# Setup a basic $PATH.  Just add system default to existing.
	# This should solve both /sbin and /usr/sbin not present when
	# doing 'su -c foo', or for something like:  PATH= rcscript start
	PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/sbin:${PATH}"

	if [ "$(/sbin/consoletype 2> /dev/null)" = "serial" ]
	then
		# We do not want colors on serial terminals
		RC_NOCOLOR="yes"
	fi
	
	for arg in $*
	do
		case "${arg}" in
			# Lastly check if the user disabled it with --nocolor argument
			--nocolor)
				RC_NOCOLOR="yes"
				;;
		esac
	done
else
	# Should we use colors ?
	if [ "${*/depend}" = "$*" ]
	then
		# Check user pref in portage
		RC_NOCOLOR="$(portageq envvar NOCOLOR 2>/dev/null)"
		
		[ "${RC_NOCOLOR}" = "true" ] && RC_NOCOLOR="yes"
	else
		# We do not want colors or stty to run during emerge depend
		RC_NOCOLOR="yes"
	fi                                                                                                                       
fi

if [ "${RC_NOCOLOR}" = "yes" ]
then
	COLS="25 80"
	ENDCOL=
	
	GOOD=
	WARN=
	BAD=
	NORMAL=
	HILITE=
	BRACKET=
	
	if [ -n "${EBUILD}" ] && [ "${*/depend}" = "$*" ]
	then
		stty cols 80 &>/dev/null
		stty rows 25 &>/dev/null
	fi
else
	COLS="`stty size 2> /dev/null`"
	COLS="`getcols ${COLS}`"
	COLS=$((${COLS} - 7))
	ENDCOL=$'\e[A\e['${COLS}'G'    # Now, ${ENDCOL} will move us to the end of the
	                               # column;  irregardless of character width
	
	GOOD=$'\e[32;01m'
	WARN=$'\e[33;01m'
	BAD=$'\e[31;01m'
	NORMAL=$'\e[0m'
	HILITE=$'\e[36;01m'
	BRACKET=$'\e[34;01m'
fi


# vim:ts=4

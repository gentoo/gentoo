# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/common-lisp-common.eclass,v 1.15 2012/06/02 19:16:31 zmedico Exp $
#
# Author Matthew Kennedy <mkennedy@gentoo.org>
#
# Sundry code common to many Common Lisp related ebuilds.

# Some handy constants

inherit eutils multilib

CLFASLROOT=/usr/$(get_libdir)/common-lisp/
CLSOURCEROOT=/usr/share/common-lisp/source/
CLSYSTEMROOT=/usr/share/common-lisp/systems/

# Many of our Common Lisp ebuilds are either inspired by, or actually
# use packages and files from the Debian project's archives.

do-debian-credits() {
	docinto debian
	for i in copyright README.Debian changelog; do
		# be silent, since all files are not always present
		dodoc "${S}"/debian/${i} &>/dev/null || true
	done
	docinto .
}

# Most of the code below is from Debian's Common Lisp Controller
# package

register-common-lisp-implementation() {
	PROGNAME=$(basename $0)
	# first check if there is at least a compiler-name:
	if [ -z "$1"  ] ; then
		cat <<EOF
usage: $PROGNAME compiler-name

registers a Common Lisp compiler to the
Common-Lisp-Controller system.
EOF
		exit 1
	fi
	IMPL=$1
	FILE="/usr/$(get_libdir)/common-lisp/bin/$IMPL.sh"
	if [ ! -f "$FILE" ] ; then
		cat <<EOF
$PROGNAME: I cannot find the script $FILE for the implementation $IMPL
EOF
		exit 2
	fi
	if [ ! -r "$FILE" ] ; then
		cat <<EOF
$PROGNAME: I cannot read the script $FILE for the implementation $IMPL
EOF
		exit 2
	fi
	# install CLC into the lisp
	sh "$FILE" install-clc || (echo "Installation of CLC failed" >&2 ; exit 3)
	mkdir /usr/$(get_libdir)/common-lisp/$IMPL &>/dev/null || true
	chown cl-builder:cl-builder /usr/$(get_libdir)/common-lisp/$IMPL

	# now recompile the stuff
	for i  in /usr/share/common-lisp/systems/*.asd	; do
		if [ -f $i -a -r $i ] ; then
			i=${i%.asd}
			package=${i##*/}
			clc-autobuild-check $IMPL $package
			if [ $? = 0 ]; then
				echo recompiling package $package for implementation $IMPL
				/usr/bin/clc-send-command --quiet recompile $package $IMPL
			fi
		fi
	done
	for i  in /usr/share/common-lisp/systems/*.system  ; do
		if [ -f $i -a -r $i ] ; then
			i=${i%.system}
			package=${i##*/}
			clc-autobuild-check $IMPL $package
			if [ $? = 0 ]; then
				echo recompiling package $package for implementation $IMPL
				/usr/bin/clc-send-command --quiet recompile $package $IMPL
			fi
		fi
	done
	echo "$PROGNAME: Compiler $IMPL installed"
}

unregister-common-lisp-implementation() {
	PROGNAME=$(basename $0)
	if [ `id -u` != 0 ] ; then
		echo $PROGNAME: you need to be root to run this program
		exit 1
	fi
	if [ -z "$1" ] ; then
		cat <<EOF
usage: $PROGNAME compiler-name

un-registers a Common Lisp compiler to the
Common-Lisp-Controller system.
EOF
		exit 1
	fi
	IMPL=$1
	IMPL_BIN="/usr/$(get_libdir)/common-lisp/bin/$IMPL.sh"
	if [ ! -f "$IMPL_BIN" ] ; then
		cat <<EOF
$PROGNAME: No implementation of the name $IMPL is registered
Cannot find the file $IMPL_BIN

Maybe you already removed it?
EOF
		exit 0
	fi
	if [ ! -r "$IMPL_BIN" ] ; then
		cat <<EOF
$PROGNAME: No implementation of the name $IMPL is registered
Cannot read the file $IMPL_BIN

Maybe you already removed it?
EOF
		exit 0
	fi
	# Uninstall the CLC
	sh $IMPL_BIN remove-clc || echo "De-installation of CLC failed" >&2
	clc-autobuild-impl $IMPL inherit
	# Just remove the damn subtree
	(cd / ; rm -rf "/usr/$(get_libdir)/common-lisp/$IMPL/" ; true )
	echo "$PROGNAME: Common Lisp implementation $IMPL uninstalled"
}

reregister-all-common-lisp-implementations() {
	# Rebuilds all common lisp implementations
	# Written by Kevin Rosenberg <kmr@debian.org>
	# GPL-2 license
	local clc_bin_dir=/usr/$(get_libdir)/common-lisp/bin
	local opt=$(shopt nullglob); shopt -s nullglob
	cd $clc_bin_dir
	for impl_bin in *.sh; do
		impl=$(echo $impl_bin | sed 's/\(.*\).sh/\1/')
		unregister-common-lisp-implementation $impl
		register-common-lisp-implementation $impl
	done
	cd - >/dev/null
	[[ $opt = *off ]] && shopt -u nullglob
}

# BIG FAT HACK: Since the Portage emerge step kills file timestamp
# information, we need to compensate by ensuring all FASL files are
# more recent than their source files.

# The following `impl-*-timestamp-hack' functions SHOULD NOT be used
# outside of this eclass.

impl-save-timestamp-hack() {
	local impl=$1
	dodir /usr/share/${impl}
	tar cpjf "${D}"/usr/share/${impl}/portage-timestamp-compensate -C "${D}"/usr/$(get_libdir)/${impl} .
}

impl-restore-timestamp-hack() {
	local impl=$1
	tar xjpfo /usr/share/${impl}/portage-timestamp-compensate -C /usr/$(get_libdir)/${impl}
}

impl-remove-timestamp-hack() {
	local impl=$1
	rm -rf /usr/$(get_libdir)/${impl} &>/dev/null || true
}

test-in() {
	local symbol=$1
	shift
	for i in $@; do
		if [ $i == ${symbol} ]; then
			return 0			# true
		fi
	done
	false
}

standard-impl-postinst() {
	local impl=$1
	rm -rf /usr/$(get_libdir)/common-lisp/${impl}/* &>/dev/null || true
	chown cl-builder:cl-builder /usr/$(get_libdir)/common-lisp/${impl}
	if test-in ${impl} cmucl sbcl; then
		impl-restore-timestamp-hack ${impl}
	fi
	chown -R root:0 /usr/$(get_libdir)/${impl}
	/usr/bin/clc-autobuild-impl ${impl} yes
	register-common-lisp-implementation ${impl}
}

standard-impl-postrm() {
	local impl=$1 impl_binary=$2
	# Since we keep our own time stamps we must manually remove them
	# here.
	if [ ! -x ${impl_binary} ]; then
		if test-in ${impl} cmucl sbcl; then
			impl-remove-timestamp-hack ${impl}
		fi
		rm -rf /usr/$(get_libdir)/common-lisp/${impl}/*
	fi
}

# Local Variables: ***
# mode: shell-script ***
# tab-width: 4 ***
# End: ***

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit toolchain-funcs

DESCRIPTION="the bind library for interix"
HOMEPAGE="http://dev.gentoo.org/~mduft"
SRC_URI=""

LICENSE="ISC BSD-4"
SLOT="0"
KEYWORDS="-* ~x86-interix"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	# scratch together the pieces of the bind installation from all over the
	# place on different interix systems, and copy the files to the local
	# prefix installation.

	if [[ -d /usr/local/bind ]]; then
		# layout as of vista onwards.
		local incdir="/usr/local/bind/include"
		local libdir="/usr/local/lib/bind"
	else
		# layout of xp and server 2003
		local incdir="/usr/local/include/bind"
		local libdir="/usr/local/lib/bind"

		# windows xp has a silly bug in the installer it seems:
		[[ -x "${incdir}/sys" ]] || chmod a+x "${incdir}/sys"
	fi

	insinto /usr/include/bind

	for obj in "${incdir}"/*; do
		[[ -f "${obj}" ]] && doins    "${obj}"
		[[ -d "${obj}" ]] && doins -r "${obj}"
	done

	cd "${T}"
	# wrap some symbols for the sake of configure link test. the libbind names
	# symbols differently than required (some extra underscores), and renames
	# them through the headers. however this is not enough, if configure checks
	# don't include header files ... :(
	$(tc-getCC) -c "${FILESDIR}"/weak.s

	mkdir "${T}"/link || die "cannot mkdir"
	cd "${T}"/link

	# now for the _magic_ part...
	ar -x "${libdir}/libbind.a"
	# permissions are _totally_ broken here...
	chmod 666 *.o

	# remove the gethostent.o file, since the contained gethostbyname* functions
	# seem to not work on older interixen, whereas the libc contained versions
	# do work well enough.
	rm gethostent.o

	# find libdb.a from the system - need the _oold_ one...
	local mydb=

	for mydb in \
			"/usr/lib/x86/libdb.a" \
			"/usr/lib/libdb.a"; do
		if test -f "${mydb}"; then
			break
		fi
	done

	# this needs a _stoneage_ berkeley db, so we really need to take the
	# systems instead if installing db ourselves. newer db's don't have the
	# requested symbols (they do support it, but with a different name). Another
	# option would be to generate wrapper symbols for the things needed, but i'd
	# rather avoid doing so, since i don't know them all.
	$(tc-getCC) -shared -Wl,-h,libbind.so.${PV} -o libbind.so.${PV} *.o \
		../weak.o "${mydb}" || die "cannot link shared libbind"

	dolib.so libbind.so.${PV}

	# to prevent accidental linking during configure tests of packages which are
	# not prepared for itx-bind, install things in a separate directory.
	# packages need to explicitly add this and the include directory for this to
	# work!
	dosym ../libbind.so.${PV} /usr/lib/bind/libbind.so
	dosym ../libbind.so.${PV} /usr/lib/bind/libresolv.so # mean, huh? :)
}

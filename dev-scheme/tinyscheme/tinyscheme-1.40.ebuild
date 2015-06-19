# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/tinyscheme/tinyscheme-1.40.ebuild,v 1.2 2011/11/30 14:51:15 grobian Exp $

EAPI="3"

inherit flag-o-matic multilib

DESCRIPTION="Lightweight scheme interpreter"
HOMEPAGE="http://tinyscheme.sourceforge.net"
SRC_URI="mirror://sourceforge/tinyscheme/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos ~x64-macos"
IUSE=""

DEPEND=""
RDEPEND=""

#S=${WORKDIR}/${MY_P}

src_prepare() {
#	cp makefile makefile.old

	#separate lines, because shell comments are weak
	sed 's/CC = gcc -fpic/CC = gcc -fpic ${CFLAGS}/' -i makefile
	sed 's/LDFLAGS/LOCAL_LDFLAGS/g' -i makefile
	sed 's/LOCAL_LDFLAGS = -shared/LOCAL_LDFLAGS = -shared ${LDFLAGS}/' -i makefile

	sed 's/DEBUG=-g -Wno-char-subscripts -O/DEBUG=/' -i makefile
	sed "s/LD)/& -Wl,-soname,lib${PN}.so.${PV}/" -i makefile

	if [[ ${CHOST} == *-darwin* ]] ; then
		append-flags -DOSX
		sed -i \
			-e 's/SOsuf=so/SOsuf=dylib/' \
			-e "s|\(\$(LD)\)[^\$]\+\(\$(\)|\1 -Wl,-install_name,${EPREFIX}/usr/lib/lib${PN}.${PV}.dylib \2|" \
			makefile || die
	fi

#	diff -u makefile.old makefile
}

src_install() {
	newbin scheme ${PN} || die "newbin failed"
	if [[ ${CHOST} == *-darwin* ]] ; then
		# this should be done for ELF (all other systems) as well, but only
		# Darwin/MachO is strict in the install_name (soname) actually pointing
		# somewhere, so we won't change the ELF scheme here (up to maintainer)
		mv libtinyscheme$(get_libname) libtinyscheme$(get_libname ${PV}) || die
		ln -s libtinyscheme$(get_libname ${PV}) libtinyscheme$(get_libname) || die
		dolib libtinyscheme$(get_libname ${PV}) || die "dolib failed"
	fi
	dolib libtinyscheme.a libtinyscheme$(get_libname) || die "dolib failed"
	dodoc Manual.txt || die "dodoc failed"

	# Bug 328967: dev-scheme/tinyscheme-1.39-r1 doesn't install header file
	insinto /usr/include/
	newins scheme.h tinyscheme.h || die "newins scheme.h tinyscheme.h failed"

	local INIT_DIR=/usr/share/${PN}/
	insinto ${INIT_DIR}
	doins init.scm || die "doins failed"
	dodir /etc/env.d/ && echo "TINYSCHEMEINIT=\"${EPREFIX}${INIT_DIR}init.scm\"" > "${ED}"/etc/env.d/50tinyscheme
}

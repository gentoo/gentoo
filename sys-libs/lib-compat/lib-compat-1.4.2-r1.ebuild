# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Compatibility C++ and libc5 and libc6 libraries for very old programs"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!<=app-emulation/emul-linux-x86-compat-20140508"

src_install() {
	if use amd64 || use x86; then
		cd x86 || die
		ABI=x86
		into /
		dolib.so ld-linux.so.1*
		rm -f ld-linux.so.1*
	#elif use alpha; then
	#	cd alpha || die
	else
		die "arch not supported"
	fi
	into /usr
	dolib.so *.so*
}

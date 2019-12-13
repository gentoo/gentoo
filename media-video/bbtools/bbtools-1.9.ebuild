# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="bbdmux, bbinfo, bbvinfo and bbainfo from Brent Beyeler"
HOMEPAGE="http://members.cox.net/beyeler/bbmpeg.html"
SRC_URI="http://files.digital-digest.com/downloads/files/encode/bbtool${PV/./}_src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

BDEPEND="app-arch/unzip"

S=${WORKDIR}

PATCHES=( "${FILESDIR}"/bbtools-${PV}-gentoo.patch )

src_prepare() {
	mv BBINFO.cpp bbinfo.cpp || die
	mv BITS.CPP bits.cpp || die
	mv BITS.H bits.h || die
	mv bbdmux.CPP bbdmux.cpp || die
	rm *.ide || die
	edos2unix *.cpp *.h

	default
}

src_configure() {
	append-lfs-flags
	tc-export CXX
}

src_install() {
	dobin bbainfo bbdmux bbinfo bbvinfo
}

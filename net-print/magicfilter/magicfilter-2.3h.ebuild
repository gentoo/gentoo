# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/magicfilter/magicfilter-2.3h.ebuild,v 1.5 2011/04/16 16:33:39 ssuominen Exp $

EAPI=4
inherit eutils toolchain-funcs

MY_P=${PN}-2.3.h

DESCRIPTION="Customizable, extensible automatic printer filter"
HOMEPAGE="http://www.pell.portland.or.us/~orc/Code/magicfilter/"
SRC_URI="http://www.pell.portland.or.us/~orc/Code/magicfilter/${MY_P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="lprng-failsafe"

DEPEND="app-text/ghostscript-gpl"
RDEPEND="${DEPEND}
	lprng-failsafe? ( net-print/lprng )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.3d-glibc-2.10.patch \
		"${FILESDIR}"/${PN}-2.3h-configure.patch \
		"${FILESDIR}"/${PN}-2.3h-makefile.patch
}

src_configure() {
	local myconf
	use lprng-failsafe && myconf="--with-lprng"

	tc-export CC
	export AC_CPP_PROG="$(tc-getCPP)"

	./configure.sh \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--filterdir=/usr/share/magicfilter/filters \
		${myconf} || die
}

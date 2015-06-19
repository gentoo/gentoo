# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/uulib/uulib-0.5.20.ebuild,v 1.22 2012/06/03 02:21:55 vapier Exp $

EAPI="4"

inherit toolchain-funcs

MY_P=uudeview-${PV}

DESCRIPTION="Library that supports Base64 (MIME), uuencode, xxencode and binhex coding"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
SRC_URI="http://www.fpx.de/fp/Software/UUDeview/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S=${WORKDIR}/${MY_P}/${PN}

src_prepare() {
	sed -i 's:\<ar\>:$(AR):' Makefile.in || die
	tc-export AR CC RANLIB
}

src_install() {
	dolib.a libuu.a
	insinto /usr/include
	doins uudeview.h
}

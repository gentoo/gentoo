# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs multilib

DESCRIPTION="proxy program for two connections set up by a UCSPI server and a UCSPI client"
HOMEPAGE="http://untroubled.org/ucspi-proxy/"
SRC_URI="http://untroubled.org/ucspi-proxy/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-libs/bglibs-1.106"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e '/^>bin$/ac:::755::ucspi-proxy' INSTHIER
}

src_configure() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	echo "${D}/usr/bin" > conf-bin
	echo "${D}/usr/share/man" > conf-man
	echo "/usr/include/bglibs" > conf-bgincs
	echo "/usr/$(get_libdir)/bglibs" > conf-bglibs
}

src_install() {
	einstall || die
	dodoc ANNOUNCEMENT NEWS README TODO
}

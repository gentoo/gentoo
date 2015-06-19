# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/i855crt/i855crt-0.4-r1.ebuild,v 1.3 2011/12/04 17:10:39 jer Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Intel Montara 855GM CRT out auxiliary driver"
HOMEPAGE="http://i855crt.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	x11-libs/libX11
	x11-libs/libXv
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-i915support.diff

	# respect CC, fix underlinking
	sed -i Makefile \
		-e 's|gcc|$(CC)|g;/LDFLAGS/{s|$| -lX11|g};s|-lXext||g' \
		|| die
	export LIBS="-lX11"
	tc-export CC

	# upstream ships it with the binary, we want to make sure we compile it
	emake clean
}

src_install() {
	dobin i855crt
	insinto /etc
	doins i855crt.conf
}

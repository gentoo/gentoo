# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xcape/xcape-1.1.ebuild,v 1.1 2014/11/05 09:45:49 pinkbyte Exp $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Utility to make modifier keys send custom key events when pressed on their own"
HOMEPAGE="https://github.com/alols/xcape"
SRC_URI="https://github.com/alols/xcape/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="x11-libs/libX11
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Fix path to man and to pkg-config
	sed -i \
		-e "/MANDIR/s:local:share:" \
		-e "s/pkg-config/$(tc-getPKG_CONFIG)/" \
		Makefile || die

	epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}

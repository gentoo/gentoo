# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xcape/xcape-1.0.ebuild,v 1.1 2013/03/10 08:50:29 pinkbyte Exp $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Utility to make modifier keys send custom key events when pressed on their own"
HOMEPAGE="https://github.com/alols/xcape"
SRC_URI="https://github.com/alols/xcape/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

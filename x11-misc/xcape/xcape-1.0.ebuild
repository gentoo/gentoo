# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

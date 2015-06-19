# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/i3lock/i3lock-2.6.ebuild,v 1.2 2015/01/21 18:22:43 xarthisius Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Simple screen locker"
HOMEPAGE="http://i3wm.org/i3lock/"
SRC_URI="http://i3wm.org/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/pam
	dev-libs/libev
	>=x11-libs/libxkbcommon-0.3.1[X]
	x11-libs/libxcb[xkb]
	x11-libs/xcb-util
	x11-libs/cairo[xcb]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
DOCS=( CHANGELOG README )

pkg_setup() {
	tc-export CC
}

src_prepare() {
	sed -i -e 's:login:system-auth:' ${PN}.pam || die
	epatch_user
}

src_install() {
	default
	doman ${PN}.1
}

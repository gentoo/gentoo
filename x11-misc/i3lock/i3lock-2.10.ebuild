# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Simple screen locker"
HOMEPAGE="https://i3wm.org/i3lock/"
SRC_URI="https://i3wm.org/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

RDEPEND="
	>=x11-libs/libxkbcommon-0.5.0[X]
	dev-libs/libev
	sys-libs/pam
	x11-libs/cairo[xcb]
	x11-libs/libxcb[xkb]
	x11-libs/xcb-util
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
DOCS=( CHANGELOG README.md )

src_prepare() {
	default

	sed -i -e 's:login:system-auth:' ${PN}.pam || die

	tc-export CC
}

src_install() {
	default
	doman ${PN}.1
}

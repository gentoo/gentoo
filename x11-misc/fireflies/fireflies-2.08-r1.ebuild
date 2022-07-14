# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Fireflies screensaver: Wicked cool eye candy"
HOMEPAGE="https://github.com/mpcomplete/fireflies"
SRC_URI="https://github.com/mpcomplete/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 icu"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	media-libs/libsdl[X,opengl,video]
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	elibc_musl? ( sys-libs/argp-standalone )"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/autoconf-archive"  # for AX_CXX_BOOL macro

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export AR
	econf \
		--with-confdir="${EPREFIX}"/usr/share/xscreensaver/config \
		--with-bindir="${EPREFIX}"/usr/$(get_libdir)/misc/xscreensaver
}

src_install() {
	default
	newbin {,${PN}-}add-xscreensaver
}

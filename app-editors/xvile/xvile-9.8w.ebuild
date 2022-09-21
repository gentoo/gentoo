# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump with app-editors/vile

MY_P="${PN/x/}-${PV}"
DESCRIPTION="VI Like Emacs -- yet another full-featured vi clone"
HOMEPAGE="https://invisible-island.net/vile/"
SRC_URI="https://invisible-island.net/archives/vile/current/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~riscv sparc x86"
IUSE="perl"

RDEPEND="~app-editors/vile-${PV}
	virtual/libcrypt:=
	>=x11-libs/libX11-1.0.0
	>=x11-libs/libXt-1.0.0
	>=x11-libs/libICE-1.0.0
	>=x11-libs/libSM-1.0.0
	>=x11-libs/libXaw-1.0.1
	>=x11-libs/libXpm-3.5.4.2
	perl? ( dev-lang/perl:= )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	sys-devel/flex"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}

src_configure() {
	econf \
		--disable-stripping \
		--with-ncurses \
		--with-pkg-config \
		--with-x \
		$(use_with perl)
}

src_install() {
	dobin xvile
	dodoc CHANGES* README doc/*.doc
	docinto html
	dodoc doc/*.html
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A boulder dash / digger-like game for console using ncurses"
HOMEPAGE="http://www.x86.no/cavezofphear/"
SRC_URI="mirror://gentoo/phear-${PV}.tar.bz2"
S="${WORKDIR}"/${P/cavezof/}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND=">=sys-libs/ncurses-5:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-no-common.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:get_data_dir(.):\"/usr/share/${PN}/\":" \
		src/{chk.c,main.c,gplot.c} \
		|| die
}

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin src/phear
	insinto /usr/share/${PN}
	doins -r data/*
	dodoc ChangeLog README* TODO
}

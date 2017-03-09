# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Bandwidth Monitor NG is a small and simple console-based bandwidth monitor"
SRC_URI="http://www.gropp.org/bwm-ng/${P}.tar.gz"
HOMEPAGE="http://www.gropp.org/"

KEYWORDS="amd64 ~arm ppc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="csv html"

RDEPEND="sys-libs/ncurses:0=
	>=sys-apps/net-tools-1.60-r1"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-buildsystem.patch
	"${FILESDIR}"/${P}-static-inline.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable csv) \
		$(use_enable html) \
		--enable-ncurses \
		--with-procnetdev
}

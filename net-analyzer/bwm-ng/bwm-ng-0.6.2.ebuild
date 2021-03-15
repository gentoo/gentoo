# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Bandwidth Monitor NG is a small and simple console-based bandwidth monitor"
HOMEPAGE="http://www.gropp.org/"
SRC_URI="https://github.com/vgropp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~arm ppc ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="+csv +html"

RDEPEND="
	>=sys-apps/net-tools-1.60-r1
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.6.2-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable csv) \
		$(use_enable html) \
		--with-ncurses \
		--with-procnetdev
}

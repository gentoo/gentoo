# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools xdg

DESCRIPTION="A hardware health information viewer, interface to lm-sensors"
HOMEPAGE="https://github.com/Mystro256/xsensors/"
SRC_URI="https://github.com/Mystro256/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	>=sys-apps/lm-sensors-3
	dev-libs/glib:2
	x11-libs/gtk+:3
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${P}-gtk220.patch
	"${FILESDIR}"/${P}-Werror.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf --without-gtk2
}

src_install() {
	default

	rm -r "${ED}"/usr/share/appdata || die
}

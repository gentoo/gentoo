# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs qmake-utils

DESCRIPTION="GTK-based GUI to configure a space navigator device"
HOMEPAGE="http://spacenav.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/spacenav/spacenavd%20config%20gui/${PN}%20${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-libs/libspnav-1[X]
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtwidgets
	x11-libs/libX11"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	>=app-misc/spacenavd-1[X]"

src_configure() {
	econf --disable-debug --disable-opt
}

src_compile() {
	local args=(
		CC="$(tc-getCC)"
		MOC="$(qt5_get_bindir)/moc"
		RCC="$(qt5_get_bindir)/rcc"
		UIC="$(qt5_get_bindir)/uic"
	)
	emake "${args[@]}"
}

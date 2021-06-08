# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg-utils

DESCRIPTION="Powerful yet simple to use screenshot software"
HOMEPAGE="https://flameshot.org https://github.com/flameshot-org/flameshot"
SRC_URI="https://github.com/flameshot-org/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Free-Art-1.3 GPL-3+ Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtwidgets:5
	dev-qt/qtsvg:5
	dev-qt/qtnetwork:5
	dev-qt/qtdbus:5
	sys-apps/dbus
"
BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}/${P}-unbundle-qtsingleapplication.patch"
	"${FILESDIR}/${P}-missing-include-fix.patch"
)

src_prepare() {
	rm -r src/third-party/singleapplication || die
	default
}

src_configure() {
	eqmake5 "CONFIG+=packaging"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

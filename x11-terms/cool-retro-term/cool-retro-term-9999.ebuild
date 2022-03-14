# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 qmake-utils xdg-utils

DESCRIPTION="terminal emulator which mimics the look and feel of the old cathode tube screens"
HOMEPAGE="https://github.com/Swordfish90/cool-retro-term"

EGIT_REPO_URI="https://github.com/Swordfish90/${PN}.git"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

DEPEND="
	dev-qt/qtdeclarative:5[localstorage]
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtquickcontrols2:5[widgets]
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
"

RDEPEND="${DEPEND}"

src_prepare() {
	default
}

src_configure() {
	eqmake5 PREFIX="/usr/bin"
}

src_install() {
	emake
	mv "${WORKDIR}/${P}/${PN}" /usr/bin/${PN}
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	rm -rf "/usr/bin/${PN}"
	xdg_icon_cache_update
	xdg_desktop_database_update
}

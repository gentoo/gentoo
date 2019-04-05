# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils xdg-utils

DESCRIPTION="Notepad++-like editor for Linux"
HOMEPAGE="http://notepadqq.altervista.org"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/notepadqq/notepadqq.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtsvg:5
	dev-qt/qttest:5
"

PATCHES=( "${FILESDIR}"/${P}-qt-5.11{,-QDateTime}.patch )

src_prepare() {
	default

	# Silence a QA warning
	sed '/^OnlyShowIn/d' \
		-i support_files/shortcuts/notepadqq.desktop \
		|| die
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}

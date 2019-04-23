# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils qmake-utils xdg-utils

DESCRIPTION="A Qt-based RSS/Atom feed reader"
HOMEPAGE="https://quiterss.org"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/QuiteRSS/quiterss.git"
	inherit git-r3
else
	SRC_URI="https://github.com/QuiteRSS/quiterss/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-db/sqlite-3.11.1:3
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[X,qt5(+)]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

DOCS=( AUTHORS CHANGELOG README.md )

src_configure() {
	local myqmakeargs=(
		PREFIX="${EPREFIX%/}/usr"
		SYSTEMQTSA=1
	)
	eqmake5 "${myqmakeargs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

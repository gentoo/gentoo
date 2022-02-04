# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop xdg-utils

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/tora-tool/tora"
	inherit git-r3
else
	SRC_URI="https://github.com/tora-tool/tora/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="SQL IDE for Oracle, MySQL and PostgreSQL dbs"
HOMEPAGE="https://github.com/tora-tool/tora/wiki"
IUSE="doc mysql oracle pch +postgres"
REQUIRED_USE="|| ( mysql oracle postgres )"

SLOT="0"
LICENSE="GPL-2"

RDEPEND="
	dev-libs/ferrisloki
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5[mysql?,postgres?]
	dev-qt/qtwidgets:5
	>=x11-libs/qscintilla-2.10.1:=[qt5(+)]
	oracle? ( dev-db/oracle-instantclient )
	postgres? ( dev-db/postgresql:* )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	cmake-utils_src_prepare

	# fixed in master, only care about recent qscintilla lib name:
	sed -e "/FIND_LIBRARY(QSCINTILLA_LIBRARY/s/qt5scintilla2/qscintilla2_qt5/" \
		-i cmake/modules/FindQScintilla.cmake || die "Failed to fix FindQScintilla.cmake"

	rm -r extlibs/{loki,qscintilla2} || die # ferrisloki, bug #383109

	sed -e "/COPYING/ d" \
		-i CMakeLists.txt || die "Removal of COPYING file failed"

	# bug 547520
	grep -rlZ '$$ORIGIN' . | xargs -0 sed -i 's|:$$ORIGIN[^:"]*||' || \
		die 'Removal of $$ORIGIN failed'
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DB2=OFF
		-DQT5_BUILD=ON
		-DWANT_INTERNAL_LOKI=OFF
		-DWANT_INTERNAL_QSCINTILLA=OFF
		-DWANT_RPM=OFF
		-DLOKI_LIBRARY="$($(tc-getPKG_CONFIG) --variable=libdir ferrisloki)/libferrisloki.so"
		-DLOKI_INCLUDE_DIR="$($(tc-getPKG_CONFIG) --variable=includedir ferrisloki)/FerrisLoki"
		$(cmake-utils_use_find_package doc Doxygen)
		-DENABLE_ORACLE=$(usex oracle)
		-DUSE_PCH=$(usex pch)
		-DENABLE_PGSQL=$(usex postgres)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	doicon src/icons/${PN}.xpm || die
	domenu src/${PN}.desktop || die
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

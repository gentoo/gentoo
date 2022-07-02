# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop toolchain-funcs xdg

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/tora-tool/tora"
	inherit git-r3
else
	SRC_URI="https://github.com/tora-tool/tora/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="SQL IDE for Oracle, MySQL and PostgreSQL dbs"
HOMEPAGE="https://github.com/tora-tool/tora/wiki"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc mysql oracle +postgres"
REQUIRED_USE="|| ( mysql oracle postgres )"

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
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=( "${FILESDIR}"/${P}-qt-includes.patch )

src_prepare() {
	cmake_src_prepare

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
		-DLOKI_LIBRARY="$($(tc-getPKG_CONFIG) --variable=libdir ferrisloki || die)/libferrisloki.so"
		-DLOKI_INCLUDE_DIR="$($(tc-getPKG_CONFIG) --variable=includedir ferrisloki || die)/FerrisLoki"
		$(cmake_use_find_package doc Doxygen)
		-DENABLE_ORACLE=$(usex oracle)
		-DUSE_PCH=OFF
		-DENABLE_PGSQL=$(usex postgres)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	doicon src/icons/tora.xpm || die
	domenu src/tora.desktop || die
}

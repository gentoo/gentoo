# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit python-single-r1 cmake-utils virtualx xdg-utils

DESCRIPTION="A simple interface for working with TeX documents"
HOMEPAGE="http://tug.org/texworks/"
SRC_URI="https://github.com/TeXworks/texworks/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="lua python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="app-text/hunspell:=
	app-text/poppler[qt5]
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5[scripttools]
	lua? ( dev-lang/lua:0 )
	python? ( ${PYTHON_DEPS} ) "

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

S=${WORKDIR}/${PN}-release-${PV}

RESTRICT="!test? ( test )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DPREFER_BUNDLED_SYNCTEX=ON
		-DWITH_LUA=$(usex lua ON OFF)
		-DWITH_PYTHON=$(usex python ON OFF)
		-DTeXworks_PLUGIN_DIR="/usr/$(get_libdir)/texworks"
		-DTeXworks_DOCS_DIR="/share/doc/${PF}"
		-DQTPDF_VIEWER=ON
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_SHARED_PLUGINS=ON
	)
	cmake-utils_src_configure
}

src_test() {
	virtx default_src_test
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx xdg

DESCRIPTION="Desktop Syncing Client for Nextcloud"
HOMEPAGE="https://github.com/nextcloud/desktop"
SRC_URI="https://github.com/nextcloud/desktop/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc dolphin nautilus test webengine"
RESTRICT="!test? ( test )"

COMMON_DEPEND=">=dev-db/sqlite-3.34:3
	>=dev-libs/openssl-1.1.0:0=
	dev-libs/qtkeychain:=[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	dolphin? (
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kio:5
	)
	nautilus? ( dev-python/nautilus-python )
	webengine? ( dev-qt/qtwebengine:5[widgets] )"

DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	dev-qt/qtxml:5
	gnome-base/librsvg
	doc? (
		dev-python/sphinx
		dev-tex/latexmk
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
	dolphin? ( kde-frameworks/extra-cmake-modules )
	test? (
		dev-util/cmocka
		dev-qt/qttest:5
	)"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/desktop-${PV/_/-}"

src_prepare() {
	# We do not package libcloudproviders
	sed -e "s/pkg_check_modules.*cloudproviders/#&/" -i CMakeLists.txt || die

	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DBUILD_UPDATER=OFF
		$(cmake_use_find_package doc Sphinx)
		$(cmake_use_find_package doc PdfLatex)
		$(cmake_use_find_package webengine Qt5WebEngine)
		$(cmake_use_find_package webengine Qt5WebEngineWidgets)
		-DBUILD_SHELL_INTEGRATION_DOLPHIN=$(usex dolphin)
		-DBUILD_SHELL_INTEGRATION_NAUTILUS=$(usex nautilus)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use doc ; then
		elog "Documentation and man pages not installed"
		elog "Enable doc USE-flag to generate them"
	fi
}

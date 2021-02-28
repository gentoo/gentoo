# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Desktop Syncing Client for Nextcloud"
HOMEPAGE="https://github.com/nextcloud/desktop"
SRC_URI="https://github.com/nextcloud/desktop/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc dolphin libressl nautilus test"

COMMON_DEPEND=">=dev-db/sqlite-3.34:3
	dev-libs/qtkeychain[gnome-keyring,qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	dolphin? (
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kio:5
	)
	!libressl? ( >=dev-libs/openssl-1.1.0:0= )
	libressl? ( >=dev-libs/libressl-3.1:0= )
	nautilus? ( dev-python/nautilus-python )"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	dev-qt/qtxml:5
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

RESTRICT="!test? ( test )"

S=${WORKDIR}/desktop-${PV/_/-}

src_prepare() {
	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die

	if ! use nautilus; then
		pushd shell_integration > /dev/null || die
		cmake_comment_add_subdirectory nautilus
		popd > /dev/null || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_DISABLE_FIND_PACKAGE_Sphinx=$(usex !doc)
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5=$(usex !dolphin)
		-DNO_SHIBBOLETH=yes
		-DUNIT_TESTING=$(usex test)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! use doc ; then
		elog "Documentation and man pages not installed"
		elog "Enable doc USE-flag to generate them"
	fi
}

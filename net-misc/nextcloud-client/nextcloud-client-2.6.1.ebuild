# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg

DESCRIPTION="Desktop Syncing Client for Nextcloud"
HOMEPAGE="https://github.com/nextcloud/desktop"
SRC_URI="https://github.com/nextcloud/desktop/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc dolphin nautilus shibboleth test"

COMMON_DEPEND=">=dev-db/sqlite-3.4:3
	>=dev-libs/openssl-1.1.0:0=
	dev-libs/qtkeychain[qt5(+)]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-fs/inotify-tools
	dolphin? (
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kio:5
	)
	nautilus? ( dev-python/nautilus-python )
	shibboleth? ( dev-qt/qtwebkit:5 )"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
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

PATCHES=( "${FILESDIR}"/${P}-include_tests.patch )

S=${WORKDIR}/desktop-${PV/_/-}

src_prepare() {
	# Keep tests in ${T}
	sed -i -e "s#\"/tmp#\"${T}#g" test/test*.cpp || die

	if ! use nautilus; then
		pushd shell_integration > /dev/null || die
		cmake_comment_add_subdirectory nautilus
		popd > /dev/null || die
	fi
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_DISABLE_FIND_PACKAGE_Sphinx=$(usex !doc)
		-DCMAKE_DISABLE_FIND_PACKAGE_KF5=$(usex !dolphin)
		-DNO_SHIBBOLETH=$(usex !shibboleth)
		-DUNIT_TESTING=$(usex test)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! use doc ; then
		elog "Documentation and man pages not installed"
		elog "Enable doc USE-flag to generate them"
	fi
}

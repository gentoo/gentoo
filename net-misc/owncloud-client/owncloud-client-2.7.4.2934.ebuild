# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

MY_PN="ownCloud"
DESCRIPTION="Synchronize files from ownCloud Server with your computer"
HOMEPAGE="https://owncloud.org/"
SRC_URI="https://download.owncloud.com/desktop/${MY_PN}/stable/${PV}/source/${MY_PN}-${PV}.tar.xz"

LICENSE="CC-BY-3.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc dolphin gnome-keyring nautilus test"

COMMON_DEPEND=">=dev-db/sqlite-3.4:3
	dev-libs/qtkeychain[gnome-keyring?,qt5(+)]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-fs/inotify-tools
	dolphin? (
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kio:5
	)
	nautilus? ( dev-python/nautilus-python )"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules
	doc? (
		dev-python/sphinx
		dev-tex/latexmk
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
	test? (
		dev-util/cmocka
		dev-qt/qttest:5
	)"

RESTRICT="!test? ( test )"

S=${WORKDIR}/${MY_PN}-${PV}

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
		-DBUILD_SHELL_INTEGRATION_DOLPHIN=$(usex dolphin)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

pkg_postinst() {
	if ! use doc ; then
		elog "Documentation and man pages not installed"
		elog "Enable doc USE-flag to generate them"
	fi
	xdg_pkg_postinst
}

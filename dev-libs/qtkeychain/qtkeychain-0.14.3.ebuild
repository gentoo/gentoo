# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild

DESCRIPTION="Qt API for storing passwords securely"
HOMEPAGE="https://github.com/frankosterfeld/qtkeychain"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/frankosterfeld/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/frankosterfeld/${PN}.git"
fi

LICENSE="BSD-2"
SLOT="0/1"
IUSE="keyring +qt5 qt6"
REQUIRED_USE="|| ( qt5 qt6 )"

DEPEND="
	keyring? (
		app-crypt/libsecret
		dev-libs/glib:2
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
	)
	qt6? ( dev-qt/qtbase:6[dbus] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	qt5? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"

DOCS=( ChangeLog ReadMe.md )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			-DECM_MKSPECS_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)/${MULTIBUILD_VARIANT}/mkspecs
			-DBUILD_TEST_APPLICATION=OFF
			-DBUILD_TRANSLATIONS=ON
			-DLIBSECRET_SUPPORT=$(usex keyring)
		)

		if [[ ${MULTIBUILD_VARIANT} == qt6 ]]; then
			mycmakeargs+=( -DBUILD_WITH_QT6=ON )
		else
			mycmakeargs+=( -DBUILD_WITH_QT6=OFF )
		fi

		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

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
IUSE="keyring test"

# tests require DBus
RESTRICT="test !test? ( test )"

RDEPEND="
	dev-qt/qtbase:6[dbus]
	keyring? (
		app-crypt/libsecret
		dev-libs/glib:2
	)
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( ChangeLog ReadMe.md )

src_configure() {
	local mycmakeargs=(
		-DECM_MKSPECS_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)/qt6/mkspecs
		-DBUILD_TEST_APPLICATION=OFF
		-DBUILD_TRANSLATIONS=ON
		-DBUILD_WITH_QT6=ON
		-DLIBSECRET_SUPPORT=$(usex keyring)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

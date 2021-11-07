# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

HOMEPAGE="https://github.com/frankosterfeld/qtkeychain"
DESCRIPTION="Qt API for storing passwords securely"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/frankosterfeld/qtkeychain/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
fi

LICENSE="BSD-2"
SLOT="0/1"
IUSE="gnome-keyring"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	gnome-keyring? (
		app-crypt/libsecret
		dev-libs/glib:2
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
"

DOCS=( ChangeLog ReadMe.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=OFF
		-DQTKEYCHAIN_STATIC=OFF
		-DBUILD_TEST_APPLICATION=OFF
		-DBUILD_TRANSLATIONS=ON
		-DLIBSECRET_SUPPORT=$(usex gnome-keyring)
	)

	cmake_src_configure
}

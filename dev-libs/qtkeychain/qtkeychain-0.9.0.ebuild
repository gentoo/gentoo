# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

HOMEPAGE="https://github.com/frankosterfeld/qtkeychain"
DESCRIPTION="Qt API for storing passwords securely"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86"
else
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
fi

LICENSE="BSD"
SLOT="0/1"
IUSE="gnome-keyring"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	gnome-keyring? ( dev-libs/glib:2 )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	gnome-keyring? ( gnome-base/libgnome-keyring )
"

DOCS=( ChangeLog ReadMe.txt )

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT4=OFF
		-DQTKEYCHAIN_STATIC=OFF
		-DBUILD_TEST_APPLICATION=OFF
		-DBUILD_TRANSLATIONS=ON
		-DLIBSECRET_SUPPORT=$(usex gnome-keyring)
	)

	cmake-utils_src_configure
}

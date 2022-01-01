# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="https://keepassxc.org"

if [[ "${PV}" != 9999 ]] ; then
	if [[ "${PV}" == *_beta* ]] ; then
		SRC_URI="https://github.com/keepassxreboot/keepassxc/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${P/_/-}"
	else
		#SRC_URI="https://github.com/keepassxreboot/keepassxc/archive/${PV}.tar.gz -> ${P}.tar.gz"
		SRC_URI="https://github.com/keepassxreboot/keepassxc/releases/download/${PV}/${P}-src.tar.xz"
		KEYWORDS="~amd64 ~arm64 ~x86"
	fi
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
fi

LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
IUSE="autotype browser ccache debug keeshare +network test yubikey"

RDEPEND="
	app-crypt/argon2:=
	dev-libs/libgcrypt:=
	>=dev-libs/libsodium-1.0.12:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-gfx/qrencode:=
	sys-libs/readline:0=
	sys-libs/zlib:=
	autotype? (
		dev-qt/qtx11extras:5
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXtst
	)
	keeshare? ( dev-libs/quazip )
	yubikey? ( sys-auth/ykpers )
"

DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qttest:5
"
BDEPEND="
	ccache? ( dev-util/ccache )
"

RESTRICT="!test? ( test )"

src_prepare() {
	 use test || \
		sed -e "/^find_package(Qt5Test/d" -i CMakeLists.txt || die

	 cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_CCACHE="$(usex ccache)"
		-DWITH_GUI_TESTS=OFF
		-DWITH_TESTS="$(usex test)"
		-DWITH_XC_AUTOTYPE="$(usex autotype)"
		-DWITH_XC_DOCS=OFF
		-DWITH_XC_BROWSER="$(usex browser)"
		-DWITH_XC_FDOSECRETS=ON
		-DWITH_XC_KEESHARE="$(usex keeshare)"
		-DWITH_XC_NETWORKING="$(usex network)"
		-DWITH_XC_SSHAGENT=ON
		-DWITH_XC_UPDATECHECK=OFF
		-DWITH_XC_YUBIKEY="$(usex yubikey)"
	)
	if [[ "${PV}" == *_beta* ]] ; then
		mycmakeargs+=( -DOVERRIDE_VERSION="${PV/_/-}" )
	fi
	cmake_src_configure
}

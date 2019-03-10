# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="https://keepassxc.org"

if [[ "${PV}" != 9999 ]] ; then
	#SRC_URI="https://github.com/keepassxreboot/keepassxc/archive/${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI="https://github.com/keepassxreboot/keepassxc/releases/download/${PV}/${P}-src.tar.xz"
	KEYWORDS="amd64 x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
fi

LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
IUSE="autotype browser debug network test yubikey"

RDEPEND="
	app-crypt/argon2:=
	dev-libs/libgcrypt:=
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	autotype? (
		dev-qt/qtx11extras:5
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXtst
	)
	browser? ( >=dev-libs/libsodium-1.0.12 )
	yubikey? ( sys-auth/ykpers )
"

DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qttest:5
	dev-qt/qtconcurrent:5
"

# Not a runtime dependency but still needed (see bug #667092)
PDEPEND="
	x11-misc/xsel
"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.3-qt-5.11-edit-entry-widget-includes.patch" #655844
	"${FILESDIR}/${PN}-dont_call_mandb.patch"
)

src_prepare() {
	 use test || \
		sed -e "/^find_package(Qt5Test/d" -i CMakeLists.txt || die

	 cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_GUI_TESTS=OFF
		-DWITH_TESTS="$(usex test)"
		-DWITH_XC_AUTOTYPE="$(usex autotype)"
		-DWITH_XC_BROWSER="$(usex browser)"
		-DWITH_XC_HTTP=OFF
		-DWITH_XC_NETWORKING="$(usex network)"
		-DWITH_XC_SSHAGENT=ON
		-DWITH_XC_YUBIKEY="$(usex yubikey)"
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

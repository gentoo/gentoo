# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SCM=""
[[ "${PV}" == 9999 ]] && SCM="git-r3"
inherit cmake-utils ${SCM}
unset SCM

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="https://github.com/keepassxreboot/keepassxc"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="https://github.com/keepassxreboot/keepassxc/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
fi

LICENSE="LGPL-2.1 GPL-2 GPL-3"
SLOT="0"
IUSE="autotype debug http test"

RDEPEND="
	dev-libs/libgcrypt:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	autotype? (
		dev-qt/qtx11extras:5
		x11-libs/libXi
		x11-libs/libXtst
	)
"
#	yubikey? ( sys-auth/libyubikey )

DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	test? ( dev-qt/qttest:5 )
"

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
		-DWITH_XC_HTTP="$(usex http)"
		#-DWITH_XC_YUBIKEY="$(usex yubikey)"
	)
	cmake-utils_src_configure
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Android File Transfer for Linux"
HOMEPAGE="https://github.com/whoozle/android-file-transfer-linux"

if [[ "${PV}" = *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/whoozle/android-file-transfer-linux.git"
else
	SRC_URI="https://github.com/whoozle/android-file-transfer-linux/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="fuse qt5"

RDEPEND="
	sys-apps/file
	sys-libs/readline:0=
	fuse? ( sys-fs/fuse:0 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"

DEPEND="${RDEPEND}"

# required to override src_prepare from xdg eclass
src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_FUSE="$(usex fuse)"
		-DBUILD_QT_UI="$(usex qt5)"
		-DBUILD_SHARED_LIB="ON"
		# Upstream recommends to keep this off as libusb is broken
		-DUSB_BACKEND_LIBUSB="OFF"
		$(usex qt5 '-DDESIRED_QT_VERSION=5' '')
	)
	cmake_src_configure
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

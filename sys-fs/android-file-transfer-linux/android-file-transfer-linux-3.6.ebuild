# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="Android File Transfer for Linux"
HOMEPAGE="https://github.com/whoozle/android-file-transfer-linux"

if [[ "${PV}" = *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/whoozle/android-file-transfer-linux.git"
else
	SRC_URI="https://github.com/whoozle/android-file-transfer-linux/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
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

src_configure() {
	local mycmakeargs=(
		-DBUILD_FUSE="$(usex fuse)"
		-DBUILD_QT_UI="$(usex qt5)"
		-DBUILD_SHARED_LIB="ON"
		# Upstream recommends to keep this off as libusb is broken
		-DUSB_BACKEND_LIBUSB="OFF"
		$(usex qt5 '-DDESIRED_QT_VERSION=5' '')
	)
	cmake-utils_src_configure
}

pkg_preinst() { gnome2_icon_savelist ; }

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

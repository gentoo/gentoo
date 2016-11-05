# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Front end to cryptsetup"
HOMEPAGE="https://mhogomchungu.github.io/zuluCrypt/"
SRC_URI="https://github.com/mhogomchungu/zuluCrypt/releases/download/${PV}/zuluCrypt-${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome +gui kde udev"

REQUIRED_USE="kde? ( gui )"

CDEPEND="
	dev-libs/libgcrypt:0=
	sys-apps/util-linux
	sys-fs/cryptsetup
	gnome? ( app-crypt/libsecret )
	gui? (
		dev-libs/libpwquality
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		kde? ( kde-frameworks/kwallet:5 )
	)
"
RDEPEND="${CDEPEND}
	udev? ( virtual/udev )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-unused-dep.patch" )

src_configure() {
	local mycmakeargs=(
		-DLIB_SUFFIX="$(get_libdir)"
		-DNOGNOME=$(usex !gnome)
		-DNOGUI=$(usex !gui)
		-DNOKDE=$(usex !kde)
		-DUDEVSUPPORT=$(usex udev)
	)

	cmake-utils_src_configure
}

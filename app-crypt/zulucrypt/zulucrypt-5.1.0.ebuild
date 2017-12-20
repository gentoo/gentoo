# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Front end to cryptsetup"
HOMEPAGE="https://mhogomchungu.github.io/zuluCrypt/"
SRC_URI="https://github.com/mhogomchungu/zuluCrypt/releases/download/${PV}/zuluCrypt-${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome kwallet +qt5 udev"

REQUIRED_USE="kwallet? ( qt5 )"

CDEPEND="
	dev-libs/libgcrypt:0=
	sys-fs/cryptsetup:=
	gnome? ( app-crypt/libsecret )
	qt5? (
		dev-libs/libpwquality
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		kwallet? ( kde-frameworks/kwallet:5 )
	)
"
RDEPEND="${CDEPEND}
	udev? ( virtual/udev )"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/zuluCrypt-${PV}"

src_configure() {
	local mycmakeargs=(
		-DLIB_SUFFIX="$(get_libdir)"
		-DNOGNOME=$(usex !gnome)
		-DNOKDE=$(usex !kwallet)
		-DNOGUI=$(usex !qt5)
		-DUDEVSUPPORT=$(usex udev)
	)
	cmake-utils_src_configure
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg cmake

DESCRIPTION="Front end to cryptsetup"
HOMEPAGE="https://mhogomchungu.github.io/zuluCrypt/"
EGIT_COMMIT="76637bb05af13744bf1734b56f67d6d5cc2343b1"
SRC_URI="https://github.com/mhogomchungu/zuluCrypt/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome kwallet +qt5 udev"
REQUIRED_USE="kwallet? ( qt5 )"

DEPEND="
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
	)"
RDEPEND="${DEPEND}
	udev? ( virtual/udev )"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/zuluCrypt-${EGIT_COMMIT}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_configure() {
	local mycmakeargs=(
		-DLIB_SUFFIX="$(get_libdir)"
		-DNOGNOME=$(usex !gnome)
		-DNOKDE=$(usex !kwallet)
		-DNOGUI=$(usex !qt5)
		-DQT5=true
		-DUDEVSUPPORT=$(usex udev)
		-DINTERNAL_ZULUPLAY=true
	)
	cmake_src_configure
}

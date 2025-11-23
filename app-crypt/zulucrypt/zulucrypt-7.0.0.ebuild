# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Front end to cryptsetup"
HOMEPAGE="https://mhogomchungu.github.io/zuluCrypt/"
SRC_URI="https://github.com/mhogomchungu/${PN}/releases/download/${PV}/${P}.tar.xz"
S="${WORKDIR}/zuluCrypt-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="keyring kwallet +qt6 udev"
REQUIRED_USE="kwallet? ( qt6 )"

DEPEND="
	dev-libs/libgcrypt:0=
	sys-fs/cryptsetup:=
	keyring? ( app-crypt/libsecret )
	qt6? (
		dev-libs/libpwquality
		dev-qt/qtbase:6[gui,network,widgets]
		kwallet? ( kde-frameworks/kwallet:6 )
	)"
RDEPEND="${DEPEND}
	udev? ( virtual/udev )"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=ON
		-DINTERNAL_ZULUPLAY=ON
		-DLIB_SUFFIX="$(get_libdir)"
		-DNOGNOME=$(usex !keyring)
		-DNOKDE=$(usex !kwallet)
		-DNOGUI=$(usex !qt6)
		-DUDEVSUPPORT=$(usex udev)
	)
	cmake_src_configure
}

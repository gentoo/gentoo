# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# skip obsolete plugins
CMAKE_QA_COMPAT_SKIP=1
inherit cmake xdg

DESCRIPTION="Front end to cryptsetup"
HOMEPAGE="https://mhogomchungu.github.io/zuluCrypt/"
SRC_URI="https://github.com/mhogomchungu/${PN}/releases/download/${PV}/${P}.tar.xz"
S="${WORKDIR}/zuluCrypt-${PV}"

# BSD-2 for bundled libs lxqt-wallet and tcplay
LICENSE="GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="keyring kwallet +qt6 udev"
REQUIRED_USE="kwallet? ( qt6 )"

DEPEND="
	dev-libs/libgcrypt:0=
	sys-apps/util-linux
	sys-fs/cryptsetup:=
	sys-fs/lvm2
	keyring? ( app-crypt/libsecret )
	qt6? (
		dev-libs/libpwquality
		dev-qt/qtbase:6[dbus,gui,network,widgets]
		kwallet? (
			kde-frameworks/knotifications:6
			kde-frameworks/kwallet:6
		)
	)
"
RDEPEND="
	${DEPEND}
	udev? ( virtual/libudev )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-7.1.0-filter_flag.patch
	"${FILESDIR}"/${PN}-7.1.0-bump_cmake.patch
	# both merged
	"${FILESDIR}"/${PN}-7.0.0-fix_linking.patch
	"${FILESDIR}"/${PN}-7.1.0-fix_kf6.patch
)

src_configure() {
	local mycmakeargs=(
		-DINTERNAL_ZULUPLAY=ON
		# fix tcplay
		-DLIB_SUFFIX=$(get_libdir)
		-DNOGNOME=$(usex !keyring)
		-DNOKDE=$(usex !kwallet)
		-DNOGUI=$(usex !qt6)
		# TODO: unbundle lxqt-wallet
		# see https://github.com/mhogomchungu/zuluCrypt/issues/242
		$(usev qt6 '-DBUILD_WITH_QT6=ON -DINTERNAL_LXQT_WALLET=ON')
		-DUDEVSUPPORT=$(usex udev)
	)
	cmake_src_configure
}

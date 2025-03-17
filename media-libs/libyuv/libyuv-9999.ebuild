# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Open source project that includes YUV scaling and conversion functionality."
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://chromium.googlesource.com/libyuv/libyuv.git"
	inherit git-r3
else
	# to diff against upstream (apparently not stable):
	# https://chromium.googlesource.com/libyuv/libyuv.git/+archive/${commit}.tar.gz
	MYTAG="0.0.1904.20250204"
	SRC_URI="https://salsa.debian.org/debian/libyuv/-/archive/upstream/${MYTAG}/libyuv-upstream-${MYTAG}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/libyuv-upstream-${MYTAG}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0/${PV}"
# TODO(NRK): enable tests
RESTRICT="test"

RDEPEND=">=media-libs/libjpeg-turbo-3.0.0"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/0001-fix-install-dirs.patch"
	"${FILESDIR}/0002-disable-static-library.patch"
	"${FILESDIR}/0003-disable-test-tools.patch"
)

src_configure() {
	mycmakeargs=(
		-DUNIT_TEST=OFF
	)
	cmake_src_configure
}

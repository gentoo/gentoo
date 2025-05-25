# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo

DESCRIPTION="Open source project that includes YUV scaling and conversion functionality."
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://chromium.googlesource.com/libyuv/libyuv.git"
	inherit git-r3
else
	# to diff against upstream (apparently not stable):
	# https://chromium.googlesource.com/libyuv/libyuv.git/+archive/${commit}.tar.gz
	SRC_URI="https://github.com/N-R-K/stable-tarball-host/releases/download/0/libyuv-${PV}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="test"
RESTRICT="!test? ( test )"

# !<net-libs/pjproject-2.15.1-r1[libyuv]: bug 955077
RDEPEND="
	!<net-libs/pjproject-2.15.1-r1[libyuv]
	>=media-libs/libjpeg-turbo-3.0.0:=
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"

PATCHES=(
	"${FILESDIR}/0001-fix-install-dirs-1909.patch"
	"${FILESDIR}/0002-disable-static-library.patch"
	"${FILESDIR}/0003-disable-test-tools.patch"
)

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
	else
		# S=${WORKDIR} is deprecated in cmake eclass
		mkdir "${P}" || die
		pushd "${P}" || die
		unpack ${A}
		popd || die
	fi
}

src_configure() {
	mycmakeargs=(
		-DUNIT_TEST=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	edo "${BUILD_DIR}"/libyuv_unittest
}

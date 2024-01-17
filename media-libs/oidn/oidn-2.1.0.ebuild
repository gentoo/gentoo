# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-single-r1

DESCRIPTION="Intel(R) Open Image Denoise library"
HOMEPAGE="https://www.openimagedenoise.org/"

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/OpenImageDenoise/oidn.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/OpenImageDenoise/${PN}/releases/download/v${PV}/${P}.src.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	test? ( apps )
"
IUSE="apps cuda hip test"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/tbb:=
	dev-lang/ispc
	cuda? ( dev-util/nvidia-cuda-toolkit )
	hip? ( dev-util/hip )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DOIDN_DEVICE_CUDA=$(usex cuda)
		-DOIDN_DEVICE_HIP=$(usex hip)
		-DOIDN_APPS=$(usex apps)
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/oidnTest || die "There were test faliures!"
}

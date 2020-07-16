# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Numerical linear algebra software package"
HOMEPAGE="https://ginkgo-project.github.io/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/ginkgo-project/ginkgo"
	SRC_URI=""
	KEYWORDS=""
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-with-attribution"
SLOT="0"
IUSE="+openmp cuda"

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-sdk )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-set_soname.patch
)

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && \
		use openmp && ! tc-has-openmp ; then
			die "Need an OpenMP capable compiler"
	fi
}

src_prepare() {
	sed -i \
		-e "s#\"lib\"#\"$(get_libdir)\"#g" \
		-e "s#\"lib/#\"$(get_libdir)/#g" \
		cmake/install_helpers.cmake || die "sed failed"

	cmake-utils_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DGINKGO_DEVEL_TOOLS=OFF
		-DGINKGO_BUILD_TESTS=OFF
		-DGINKGO_BUILD_BENCHMARKS=OFF
		-DGINKGO_BUILD_REFERENCE=ON
		-DGINKGO_BUILD_OMP="$(usex openmp)"
		-DGINKGO_BUILD_CUDA="$(usex cuda)"
	)
	cmake-utils_src_configure
}

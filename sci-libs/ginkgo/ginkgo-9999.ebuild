# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Numerical linear algebra software package"
HOMEPAGE="https://ginkgo-project.github.io/"

inherit git-r3
EGIT_REPO_URI="https://github.com/ginkgo-project/ginkgo"
SRC_URI=""
KEYWORDS=""

LICENSE="BSD-with-attribution"
SLOT="0"
IUSE=""

# TODO: add slepc use flag once slepc is packaged for gentoo-science
REQUIRED_USE=""

RDEPEND=""

DEPEND=""

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
		-DGINKGO_BUILD_OMP=ON
	)
	cmake-utils_src_configure
}

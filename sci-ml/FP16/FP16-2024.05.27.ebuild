# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )
inherit python-r1 cmake

CommitId=95163a75c51bc8dc29f72d0d7419ec50132984ff

DESCRIPTION="conversion to/from half-precision floating point formats"
HOMEPAGE="https://github.com/Maratyszcza/FP16/"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="dev-libs/psimd"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	dev-python/peachpy[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-2021.03.20-gentoo.patch
)

src_prepare() {
	cmake_src_prepare
	mkdir -p module/fp16 || die
	cp include/fp16/*py module/fp16 || die
}

src_configure() {
	local mycmakeargs=(
		-DFP16_BUILD_BENCHMARKS=OFF
		-DFP16_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}

python_install() {
	python_domodule module/fp16
}

src_install() {
	cmake_src_install
	rm "${ED}"/usr/include/fp16/*.py || die
	python_foreach_impl python_install
}

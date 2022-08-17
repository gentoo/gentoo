# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8,9,10} )
inherit python-r1 cmake

CommitId=0a92994d729ff76a58f692d3028ca1b64b145d91

DESCRIPTION="conversion to/from half-precision floating point formats"
HOMEPAGE="https://github.com/Maratyszcza/FP16/"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="dev-libs/psimd"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	dev-python/PeachPy[${PYTHON_USEDEP}]
"
BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
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
	rm "${D}"/usr/include/fp16/*.py || die
	python_foreach_impl python_install
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python{3_6,3_7} )

inherit cmake-utils distutils-r1 toolchain-funcs

DESCRIPTION="disassembly/disassembler framework + bindings"
HOMEPAGE="http://www.capstone-engine.org/"
SRC_URI="https://github.com/aquynh/${PN}/archive/${PV/_rc/-rc}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/4" # libcapstone.so.4
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RESTRICT="!test? ( test )"

IUSE="python static-libs test"
RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S=${WORKDIR}/${P/_rc/-rc}

wrap_python() {
	if use python; then
		pushd bindings/python >/dev/null || die
		distutils-r1_${1} "$@"
		popd >/dev/null
	fi
}

src_prepare() {
	cmake-utils_src_prepare

	wrap_python ${FUNCNAME}
}

src_configure() {
	local mycmakeargs=(
		-DCAPSTONE_BUILD_TESTS="$(usex test)"
		-DCAPSTONE_BUILD_STATIC="$(usex static-libs)"
	)
	cmake-utils_src_configure

	wrap_python ${FUNCNAME}
}

src_compile() {
	cmake-utils_src_compile

	wrap_python ${FUNCNAME}
}

src_test() {
	cmake-utils_src_test

	wrap_python ${FUNCNAME}
}

src_install() {
	cmake-utils_src_install

	wrap_python ${FUNCNAME}
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit cmake distutils-r1 toolchain-funcs

DESCRIPTION="disassembly/disassembler framework + bindings"
HOMEPAGE="https://www.capstone-engine.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/capstone-engine/capstone.git"
	EGIT_REPO_BRANCH="next"
else
	SRC_URI="https://github.com/capstone-engine/capstone/archive/${PV/_rc/-rc}.tar.gz -> ${P}.tar.gz"
	S=${WORKDIR}/${P/_rc/-rc}
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0/5" # libcapstone.so.5

IUSE="python static-libs test"
RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
"
BDEPEND="${DISTUTILS_DEPS}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

distutils_enable_tests setup.py

PATCHES=(
	"${FILESDIR}"/${P}-pkgconfig.patch
	"${FILESDIR}"/${P}-oob-mem-access.patch
)

if [[ ${PV} == *_rc* ]]; then
	# Upstream doesn't flag release candidates (bug 858350)
	QA_PKGCONFIG_VERSION=""
fi

wrap_python() {
	local phase=$1
	shift

	if use python; then
		pushd bindings/python >/dev/null || die
		distutils-r1_${phase} "$@"
		popd >/dev/null || die
	fi
}

src_prepare() {
	tc-export RANLIB
	cmake_src_prepare

	wrap_python ${FUNCNAME}
}

src_configure() {
	local mycmakeargs=(
		-DCAPSTONE_BUILD_TESTS="$(usex test)"
	)
	cmake_src_configure

	wrap_python ${FUNCNAME}
}

src_compile() {
	cmake_src_compile

	wrap_python ${FUNCNAME}
}

src_test() {
	cmake_src_test

	wrap_python ${FUNCNAME}
}

src_install() {
	cmake_src_install

	wrap_python ${FUNCNAME}

	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die
	fi
}

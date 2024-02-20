# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 edo toolchain-funcs

COMMIT="531a49062975d6d2cd5d69b75ad5481a8c0e18c5"

DESCRIPTION="Very low footprint JSON parser written in portable ANSI C"
HOMEPAGE="https://github.com/json-parser/json-parser"
SRC_URI="https://github.com/json-parser/json-parser/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD-2"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
"
BDEPEND="
	python? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
		dev-python/cython[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/${PN}-1.1.0-pkgconfig-libdir.patch" )

wrap_python() {
	local phase=$1
	shift

	if use python; then
		pushd bindings/python || die
		distutils-r1_${phase} "${@}"
		popd
	fi
}

src_prepare() {
	default
	wrap_python ${FUNCNAME}
}

src_configure() {
	default
	wrap_python ${FUNCNAME}
}

src_compile() {
	default
	wrap_python ${FUNCNAME}
}

python_test() {
	"${EPYTHON}" test.py || die "Tests failed with ${EPYTHON}"
}

src_test() {
	edo $(tc-getCC) ${CFLAGS} -I. ${CPPFLAGS} ${LDFLAGS} -o tests/test tests/test.c json.o -lm
	pushd tests > /dev/null || die
	edo ./test
	use python && distutils-r1_src_test
	popd
}

src_install() {
	emake DESTDIR="${D}" install-shared
	dodoc README.md AUTHORS
	wrap_python ${FUNCNAME}
}

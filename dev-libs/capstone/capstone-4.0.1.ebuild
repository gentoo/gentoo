# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="disassembly/disassembler framework + bindings"
HOMEPAGE="http://www.capstone-engine.org/"
SRC_URI="https://github.com/aquynh/${PN}/archive/${PV/_rc/-rc}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/4" # libcapstone.so.4
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RESTRICT="!test? ( test )"

IUSE="python test"
RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0-FLAGS.patch
	"${FILESDIR}"/${PN}-4.0-no-fuzz-tests.patch
)

S=${WORKDIR}/${P/_rc/-rc}

wrap_python() {
	if use python; then
		pushd bindings/python >/dev/null || die
		distutils-r1_${1} "$@"
		popd >/dev/null
	fi
}

src_prepare() {
	default

	wrap_python ${FUNCNAME}
}

src_configure() {
	{
		cat <<-EOF
		# Gentoo overrides:
		#   verbose build
		V = 1
		#   toolchain
		AR = $(tc-getAR)
		CC = $(tc-getCC)
		RANLIB = $(tc-getRANLIB)
		#  toolchain flags
		CFLAGS = ${CFLAGS}
		LDFLAGS = ${LDFLAGS}
		#  libs
		LIBDIRARCH = $(get_libdir)
		PREFIX = ${EPREFIX}/usr
		EOF
	} >> config.mk || die

	if ! use test; then
		# Don't build tests if not requested: bug #663006
		sed -i tests/Makefile -e 's@all: $(BINARY)@all:@' || die
	fi

	wrap_python ${FUNCNAME}
}

src_compile() {
	default

	wrap_python ${FUNCNAME}
}

src_test() {
	default

	wrap_python ${FUNCNAME}
}

src_install() {
	default

	wrap_python ${FUNCNAME}
}

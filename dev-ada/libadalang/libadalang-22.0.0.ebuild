# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
ADA_COMPAT=( gnat_202{0,1} )

inherit ada python-single-r1

DESCRIPTION="high performance semantic engine for the Ada programming language"
HOMEPAGE="https://libre.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test shared static-libs static-pic"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyyaml
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},gmp,iconv,shared?,static-libs?,static-pic?]
	${ADA_DEPS}
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]
	$(python_gen_cond_dep '
		dev-ada/langkit[${PYTHON_USEDEP}]
	')
"
BDEPEND="test? (
		dev-ml/dune
		dev-ml/zarith
		dev-ml/camomile
		dev-ml/ocaml-ctypes
	)"

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
	libType=''
	if use static-libs; then
		libType+=',static'
	fi
	if use static-pic; then
		libType+=',static-pic'
	fi
	if use shared; then
		libType+=',relocatable'
	fi
	libType=${libType:1}
}

src_configure() {
	${EPYTHON} manage.py generate -v debug || die
}

src_compile() {
	${EPYTHON} manage.py build -v \
		--gargs "-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS}" \
		--library-types=${libType} || die
}

src_test() {
	#eval $(${EPYTHON} ./manage.py setenv)
	${EPYTHON} manage.py test --restricted-env -j 1 |& > /dev/null
	${EPYTHON} manage.py test --restricted-env -j 1 |& tee libadalang.testOut
	grep -qw FAIL libadalang.testOut && die
}

src_install() {
	${EPYTHON} manage.py \
		install "${D}"/usr \
		--library-types=${libType} || die
	rm -r "${D}"/usr/python || die
	python_domodule build/python/libadalang
	rm -r "${D}"/usr/ocaml || die
}

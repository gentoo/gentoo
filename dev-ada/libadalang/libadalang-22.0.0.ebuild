# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
ADA_COMPAT=( gnat_202{0,1} gcc_12_2_0 )

inherit ada python-single-r1 multiprocessing

DESCRIPTION="high performance semantic engine for the Ada programming language"
HOMEPAGE="https://libre.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="test +static-libs static-pic"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyyaml
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},gmp,iconv,shared,static-libs?,static-pic?]
	${ADA_DEPS}
	${PYTHON_DEPS}
	dev-ada/langkit[${ADA_USEDEP},shared,static-libs?,static-pic?]
	$(python_gen_cond_dep '
		dev-ada/langkit[${PYTHON_USEDEP}]
	')"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]
"
BDEPEND="test? (
		dev-ml/dune
		dev-ml/zarith
		dev-ml/camomile
		dev-ml/ocaml-ctypes
		dev-ada/e3-testsuite
		<dev-lang/ocaml-4.14
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
	libType+=',relocatable'
	libType=${libType:1}
}

src_prepare() {
	default
	rm -r testsuite/tests/misc/copyright || die
}

src_configure() {
	${EPYTHON} manage.py generate -v debug || die
}

src_compile() {
	${EPYTHON} manage.py build -v \
		--build-mode "prod" \
		-j$(makeopts_jobs) \
		--gargs "-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} -largs:C ${LDFLAGS}" \
		--library-types=${libType} || die
	GPR_PROJECT_PATH="${S}"/build \
		gprbuild -P contrib/highlight/highlight.gpr \
		-j$(makeopts_jobs) -v \
		-XBUILD_MODE=prod \
		-XLIBRARY_TYPE=relocatable \
		-XXMLADA_BUILD=relocatable \
		-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} \
		-largs:C ${LDFLAGS} \
		|| die
}

src_test() {
	${EPYTHON} manage.py test \
		--build-mode "prod" \
		--restricted-env -j 1 \
		|& tee libadalang.testOut
	grep -qw FAIL libadalang.testOut && die
}

src_install() {
	${EPYTHON} manage.py \
		install "${D}"/usr \
		--build-mode "prod" \
		--library-types=${libType} || die
	rm -r "${D}"/usr/python || die
	python_domodule build/python/libadalang
	rm -r "${D}"/usr/ocaml || die
}

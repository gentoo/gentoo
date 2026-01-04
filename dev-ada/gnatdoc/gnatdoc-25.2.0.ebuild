# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
ADA_COMPAT=( gcc_{14..15} )

inherit ada python-single-r1 multiprocessing

DESCRIPTION="GNAT Documentation Generation Tool"
HOMEPAGE="https://github.com/AdaCore/gnatdoc"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	${ADA_REQUIRED_USE}"
IUSE="doc static-libs static-pic"

RDEPEND="${ADA_DEPS}
	${PYTHON_DEPS}
	=dev-ada/gpr-25*[${ADA_USEDEP},shared(+),static-libs?]
	dev-ada/markdown:=[${ADA_USEDEP}]
	=dev-ada/vss-text-25*:=[${ADA_USEDEP},static-libs?]
	=dev-ada/libadalang-25*:=[${ADA_USEDEP},static-libs?,static-pic?]
	dev-ada/libadalang:=[${PYTHON_SINGLE_USEDEP}]
"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

pkg_setup() {
	python-single-r1_pkg_setup
	ada_pkg_setup
}

src_compile() {
	build() {
		gprbuild -v -j$(makeopts_jobs) -p -P gnat/libgnatdoc.gpr \
			-XLIBRARY_TYPE=$1 -cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} \
			-largs ${LDFLAGS} || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprbuild -v -j$(makeopts_jobs) -p -P gnat/gnatdoc.gpr \
		-XLIBRARY_TYPE=relocatable -cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} \
		-largs ${LDFLAGS} || die
	if use doc; then
		emake -C documentation/users_guide html
	fi
}

src_test() {
	gprbuild -v -j$(makeopts_jobs) -p -P gnat/tests/test_drivers.gpr \
		-XLIBRARY_TYPE=relocatable || die
	PATH="${S}/bin:$PATH" \
		${EPYTHON} testsuite/testsuite.py || die
}

src_install() {
	build() {
		gprinstall -v -p -P gnat/libgnatdoc.gpr \
			-XLIBRARY_TYPE=$1 --prefix="${D}"/usr || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprinstall -v -p -P gnat/gnatdoc.gpr \
		-XLIBRARY_TYPE=relocatable --prefix="${D}"/usr || die
	use doc && HTML_DOCS=( documentation/users_guide/_build/html/* )
	einstalldocs
}

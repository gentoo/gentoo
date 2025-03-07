# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_14 )
PYTHON_COMPAT=( python3_{10..13} pypy3 )
inherit ada python-any-r1 multiprocessing

commitId=a5997083efc0ae97ec089b18931c765d43301072

DESCRIPTION="Refactoring tools for the Ada programming language"
HOMEPAGE="https://github.com/AdaCore/lal-refactor"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs static-pic test"
REQUIRED_USE="${ADA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${ADADEPS}
	dev-ada/libadalang:${SLOT}[${ADA_USEDEP},static-libs?,static-pic?]
	dev-ada/libadalang-tools:${SLOT}[${ADA_USEDEP},shared,static-libs?,static-pic?]"
BDEPEND="
	dev-ada/gprbuild[${ADA_USEDEP}]
	test? (
		$(python_gen_any_dep '
			dev-ada/e3-testsuite[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	python_has_version "dev-ada/e3-testsuite[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
	ada_pkg_setup
}

src_compile() {
	build () {
		gprbuild -v -k -XLAL_REFACTOR_LIBRARY_TYPE=$1 -XLIBRARY_TYPE=$1 \
			-P gnat/lal_refactor.gpr -p -j$(makeopts_jobs) \
			-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic

	gprbuild -v -k -XLAL_REFACTOR_LIBRARY_TYPE=relocatable \
		-XLIBRARY_TYPE=relocatable -Pgnat/lal_refactor_driver.gpr -p \
		-j$(makeopts_jobs) -largs ${LDFLAGS} -cargs ${ADAFLAGS} || die

	if use test; then
		GPR_PROJECT_PATH=gnat \
			gprbuild -v -k -XLAL_REFACTOR_LIBRARY_TYPE=relocatable  \
			-XLIBRARY_TYPE=relocatable \
			-P testsuite/ada_drivers/gnat/lal_refactor_test_drivers.gpr \
			-p -j$(makeopts_jobs) || die
	fi
}

src_test() {
	${PYTHON} testsuite/testsuite.py || die
}

src_install() {
	build () {
		gprinstall -XLAL_REFACTOR_LIBRARY_TYPE=$1 -XLIBRARY_TYPE=$1 \
			--prefix="${D}"/usr --sources-subdir=include/lal-refactor \
			--build-name=$1 --build-var=LIBRARY_TYPE -P gnat/lal_refactor.gpr \
			-p -f || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprinstall -XLAL_REFACTOR_LIBRARY_TYPE=relocatable \
		-XLIBRARY_TYPE=relocatable --prefix="${D}"/usr \
		-P gnat/lal_refactor_driver.gpr -p -f || die

	einstalldocs
	rm -rf "${D}"/usr/share/gpr/manifests
}

# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 gcc_14 )
inherit ada multiprocessing

commitId=a5997083efc0ae97ec089b18931c765d43301072

DESCRIPTION="Refactoring tools for the Ada programming language"
HOMEPAGE="https://github.com/AdaCore/lal-refactor"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs static-pic"
REQUIRED_USE="${ADA_REQUIRED_USE}"

RDEPEND="${ADADEPS}
	dev-ada/libadalang-tools:=[${ADA_USEDEP},shared,static-libs?,static-pic?]"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

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

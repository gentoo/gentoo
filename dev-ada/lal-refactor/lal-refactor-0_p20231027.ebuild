# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

commitId=a5997083efc0ae97ec089b18931c765d43301072

DESCRIPTION="Refactoring tools for the Ada programming language"
HOMEPAGE="https://github.com/AdaCore/lal-refactor"
SRC_URI="https://github.com/AdaCore/${PN}/archive/${commitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="${ADADEPS}
	dev-ada/libadalang-tools[${ADA_USEDEP},shared?,static-libs?,static-pic?]"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

S="${WORKDIR}"/${PN}-${commitId}

src_compile() {
	build () {
		gprbuild -v -k -XLIBRARY_TYPE=$1 -j$(makeopts_jobs) -p \
			-XLAL_REFACTOR_LIBRARY_TYPE=$1 \
			-XLAL_REFACTOR_BUILD_MODE=prod \
			-P gnat/lal_refactor.gpr \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} || die

	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi

	if use static-libs; then
		libtype='static'
	elif use static-pic; then
		libtype='static-pic'
	elif use shared; then
		libtype='relocatable'
	fi
	gprbuild -v -k -XLIBRARY_TYPE=${libtype} -j$(makeopts_jobs) -p \
		-XLAL_REFACTOR_LIBRARY_TYPE=${libtype} \
		-XLAL_REFACTOR_BUILD_MODE=prod \
		-Pgnat/lal_refactor_driver.gpr \
		-largs ${LDFLAGS} \
		-cargs ${ADAFLAGS} || die
}

src_install() {
	build () {
		gprinstall \
			-XLAL_REFACTOR_LIBRARY_TYPE=$1 \
			-XLIBRARY_TYPE=$1 \
			-XLAL_REFACTOR_BUILD_MODE=prod \
			--prefix="${D}"/usr \
			--sources-subdir=include/lal-refactor \
			--build-name=$1 \
			--build-var=LIBRARY_TYPE \
			-P gnat/lal_refactor.gpr -p -f || die
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
	gprinstall \
		-XLAL_REFACTOR_LIBRARY_TYPE=${libtype} \
		-XLIBRARY_TYPE=${libtype} \
		-XBUILD_MODE=prod \
		--prefix="${D}"/usr \
		-P gnat/lal_refactor_driver.gpr \
		-p \
		-f || die

	einstalldocs
	rm -rf "${D}"/usr/share/gpr/manifests
}

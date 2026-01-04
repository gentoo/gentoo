# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_12 gcc_13 gcc_14 )

inherit ada multiprocessing

DESCRIPTION="LibGPR2 - Parser for GPR Project files"
HOMEPAGE="https://github.com/AdaCore/gpr"
SRC_URI="https://github.com/AdaCore/${PN}/releases/download/v${PV}/gpr2-with-lkparser-$(ver_cut 1-2).tgz"

S="${WORKDIR}"/${PN}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	<dev-ada/gnatcoll-core-26[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},shared?,static-libs?,static-pic?,iconv(+),gmp]
"

DEPEND="${RDEPEND}
	dev-ada/gprconfig_kb[${ADA_USEDEP}]
	dev-ada/gprbuild[${ADA_USEDEP}]"

src_compile() {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
			-XGPR2_BUILD=release -XXMLADA_BUILD=$1 gpr2.gpr \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} || die "gprbuild failed"
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

	gprbuild -p -m -v -j$(makeopts_jobs) -aP . -XGPR2_BUILD=release \
		-XLIBRARY_TYPE=${libtype} -XXMLADA_BUILD=${libtype} tools/gpr2-tools.gpr \
		-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die
}

src_install() {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 -f -p -v -XGPR2_BUILD=release \
			--prefix="${D}/usr" -XXMLADA_BUILD=$1 \
			--build-name=$1 --build-var=LIBRARY_TYPE \
			--build-var=GPR2_LIBRARY_TYPE gpr2.gpr || die
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
	gprinstall -p -f -v -aP . -XGPR2_BUILD=release --prefix="${D}/usr" \
		-XLIBRARY_TYPE=${libtype} -XXMLADA_BUILD=${libtype} \
		--build-name=${libtype} --mode=usage tools/gpr2-tools.gpr || die

	einstalldocs

	rm "${D}"/usr/bin/gprclean || die
	rm "${D}"/usr/bin/gprconfig || die
	rm "${D}"/usr/bin/gprinstall || die
	rm "${D}"/usr/bin/gprls || die
}

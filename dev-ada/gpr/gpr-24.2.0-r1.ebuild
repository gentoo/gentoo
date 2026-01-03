# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_13 gcc_14 )

inherit ada multiprocessing

DESCRIPTION="LibGPR2 - Parser for GPR Project files"
HOMEPAGE="https://github.com/AdaCore/gpr"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}-next.tar.gz
	-> ${P}-next.tar.gz"

S="${WORKDIR}"/${P}-next

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs static-pic"
REQUIRED_USE="${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}
	dev-ada/xmlada[${ADA_USEDEP},shared,static-libs?,static-pic?]
	<dev-ada/gnatcoll-core-26[${ADA_USEDEP},shared,static-libs?,static-pic?]
	dev-ada/gnatcoll-bindings[${ADA_USEDEP},shared,static-libs?,static-pic?]
	dev-ada/gnatcoll-bindings[iconv(+),gmp]
"

DEPEND="${RDEPEND}
	dev-ada/gprconfig_kb[${ADA_USEDEP}]
	dev-ada/gprbuild[${ADA_USEDEP}]"

src_compile() {
	emake GPR2KBDIR=/usr/share/gprconfig .build/kb/config.kb
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
			-XGPR2_BUILD=release -XXMLADA_BUILD=$1 gpr2.gpr \
			-largs ${LDFLAGS} \
			-cargs ${ADAFLAGS} || die "gprbuild failed"
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic

	gprbuild -p -m -v -j$(makeopts_jobs) -aP . -XGPR2_BUILD=release \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable \
		tools/gpr2-tools.gpr \
		-largs ${LDFLAGS} -cargs ${ADAFLAGS} || die
}

src_install() {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 -f -p -v -XGPR2_BUILD=release \
			--prefix="${D}/usr" -XXMLADA_BUILD=$1 \
			--build-name=$1 --build-var=LIBRARY_TYPE \
			--build-var=GPR2_LIBRARY_TYPE gpr2.gpr || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	gprinstall -p -f -v -aP . -XGPR2_BUILD=release --prefix="${D}/usr" \
		-XLIBRARY_TYPE=relocatable -XXMLADA_BUILD=relocatable \
		--build-name=relocatable --mode=usage tools/gpr2-tools.gpr || die

	einstalldocs

	rm "${D}"/usr/bin/gprconfig || die
	rm -r "${D}"/usr/share/gpr/manifests
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{14..16} )
inherit ada multiprocessing

DESCRIPTION="Libadalang-based tools: gnatpp, gnatmetric and gnatstub"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs static-pic test"

REQUIRED_USE="${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}
	dev-ada/templates-parser[${ADA_USEDEP},shared(+),static-libs?]
	dev-ada/vss-text[${ADA_USEDEP},shared(+),static-libs?,static-pic?]
	dev-ada/libadalang:${SLOT}[${ADA_USEDEP},static-libs?,static-pic?]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ada/gprbuild[${ADA_USEDEP}]
	test? ( dev-ada/aunit[${ADA_USEDEP}] )
"
RESTRICT="!test? ( test )"

src_prepare() {
	default
	rm -r testsuite/tests/metric/agg.RC12-009 || die
	rm -r testsuite/tests/pp/agg.P510-022 || die
	rm -r testsuite/tests/stub/agg.S410-054 || die
}

src_compile() {
	single_build () {
		gprbuild -v -k -p -j$(makeopts_jobs) -XLIBRARY_TYPE=$1 \
			-XXMLADA_BUILD=$1 -XLALTOOLS_BUILD_MODE=dev \
			-XLALTOOLS_SET=all \
			-P $2 \
			-cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} || die
	}

	full_build () {
		single_build $1 src/build.gpr
		single_build $1 src/lal_tools.gpr
		if use test; then
			single_build $1 testsuite/ada_drivers/indent/indent.gpr
			single_build $1 testsuite/ada_drivers/outgoing_calls/outgoing_calls.gpr
			single_build $1 testsuite/ada_drivers/partial_gnatpp/partial_gnatpp.gpr
		fi
	}

	full_build relocatable
	use static-libs && full_build static
	use static-pic  &&  full_build static-pic
}

src_test() {
	PATH="${S}/bin:${PATH}" \
		GPR_PROJECT_PATH="${S}"/src/tgen/tgen_rts \
		LIBRARY_TYPE=static \
		testsuite/testsuite.py --jobs=1 || die
}

src_install() {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 \
			-XLALTOOLS_BUILD_MODE=dev \
			--prefix="${D}"/usr \
			--sources-subdir=include/lal_tools \
			--build-name=$1 \
			--build-var=LIBRARY_TYPE --build-var=LAL_TOOLS_BUILD \
			-P src/lal_tools.gpr -p -f || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	dobin bin/{gnatmetric,gnatpp,gnatstub}
	einstalldocs
}

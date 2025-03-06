# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_14 )
inherit ada multiprocessing

DESCRIPTION="Libadalang-based tools: gnatpp, gnatmetric and gnatstub"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+shared static-libs static-pic test"

# Some test are not working
RESTRICT="test"

REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}
	dev-ada/templates-parser[${ADA_USEDEP},shared?,static-libs?]
	>=dev-ada/VSS-24.0.0[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	dev-ada/libadalang:${SLOT}[${ADA_USEDEP},static-libs?,static-pic?]"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

src_compile() {
	gprbuild -v -k -p -j$(makeopts_jobs) -XLIBRARY_TYPE=relocatable \
		-XXMLADA_BUILD=relocatable -XLALTOOLS_BUILD_MODE=prod \
		-XLALTOOLS_SET=all -P src/build.gpr \
		-cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} || die
	build () {
		gprbuild -v -k -p -j$(makeopts_jobs) -XLIBRARY_TYPE=$1 \
			-XXMLADA_BUILD=$1 -XLALTOOLS_SET=all -P src/lal_tools.gpr \
			-cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	if use test; then
		cd testsuite/ada_drivers
		gprbuild -v -k -p -j$(makeopts_jobs) -XLIBRARY_TYPE=relocatable \
			-XXMLADA_BUILD=relocatable -XLALTOOLS_SET=all \
			-P gen_marshalling_lib/tgen_marshalling.gpr \
			-cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} || die
		gprbuild -v -k -p -j$(makeopts_jobs) -XLIBRARY_TYPE=relocatable \
			-XXMLADA_BUILD=relocatable -XLALTOOLS_SET=all \
			-P indent/indent.gpr \
			-cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} || die
		gprbuild -v -k -p -j$(makeopts_jobs) -XLIBRARY_TYPE=relocatable \
			-XXMLADA_BUILD=relocatable -XLALTOOLS_SET=all \
			-P outgoing_calls/outgoing_calls.gpr \
			-cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} || die
		gprbuild -v -k -p -j$(makeopts_jobs) -XLIBRARY_TYPE=relocatable \
			-XXMLADA_BUILD=relocatable -XLALTOOLS_SET=all \
			-P partial_gnatpp/partial_gnatpp.gpr \
			-cargs:Ada ${ADAFLAGS} -largs ${LDFLAGS} || die
		cd ../..
	fi
}

src_test() {
	GPR_PROJECT_PATH="${S}"/src/tgen/tgen_rts \
		LIBRARY_TYPE=static \
		testsuite/testsuite.py || die
}

src_install() {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 --prefix="${D}"/usr \
			--sources-subdir=include/lal_tools \
			--build-name=$1 --build-var=LIBRARY_TYPE \
			--build-var=LAL_TOOLS_BUILD \
			-P src/lal_tools.gpr -p -f || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
	dobin bin/gnat*
	insinto /usr/share/tgen
	doins -r src/tgen/tgen_rts
	doins -r share/tgen/templates
	einstalldocs
}

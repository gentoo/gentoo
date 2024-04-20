# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="Libadalang-based tools: gnatpp, gnatmetric and gnatstub"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic"

RESTRICT="test"

REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}
	dev-ada/templates-parser[${ADA_USEDEP},shared?,static-libs?]
	>=dev-ada/VSS-24.0.0[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	dev-ada/libadalang:=[${ADA_USEDEP},static-libs?,static-pic?]"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

src_compile() {
	build () {
		gprbuild -v -k -XLIBRARY_TYPE=$1 -XBUILD_MODE=prod \
			-P src/lal_tools.gpr -p -j$(makeopts_jobs) \
			-cargs:Ada ${ADAFLAGS} || die
		gprbuild -v -k -XLIBRARY_TYPE=$1 -XXMLADA_BUILD=$1 \
			-XBUILD_MODE=prod -XLALTOOLS_SET=all \
			-P src/build.gpr -p -j$(makeopts_jobs) \
			-cargs:Ada ${ADAFLAGS} || die
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
}

src_install() {
	build () {
		gprinstall -XLIBRARY_TYPE=$1 -XBUILD_MODE=prod \
			--prefix="${D}"/usr --sources-subdir=include/lal_tools \
			--build-name=$1 --build-var=LIBRARY_TYPE \
			--build-var=LAL_TOOLS_BUILD \
			-P src/lal_tools.gpr -p -f || die
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
	dobin bin/gnat{metric,pp,stub,test}
	einstalldocs
}

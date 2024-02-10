# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="GPR Unit Provider"
HOMEPAGE="https://github.com/AdaCore/gpr-unit-provider"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+shared static-libs static-pic"

RDEPEND="${ADA_DEPS}
	dev-ada/gpr:=[${ADA_USEDEP},shared?]
	dev-ada/libadalang:=[${ADA_USEDEP},static-libs?,static-pic?]"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"
REQUIRED_USE="${ADA_REQUIRED_USE}
	|| ( shared static-libs static-pic )"

src_compile() {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v -XLIBRARY_TYPE=$1 \
		-XGPR_UNIT_PROVIDER_BUILD=release -XXMLADA_BUILD=$1 \
		-P gpr_unit_provider.gpr \
		-largs ${LDFLAGS} \
		-cargs ${ADAFLAGS} || die "gprbuild failed"
	}
	use static-libs && build static
	use shared && build relocatable
	use static-pic && build static-pic
}

src_install() {
	if use static-libs; then
		emake prefix="${D}"/usr \
			install-static
	fi
	if use shared; then
		emake prefix="${D}"/usr \
			install-relocatable
	fi
	if use static-pic; then
		emake prefix="${D}"/usr \
			install-static-pic
	fi
	einstalldocs
}

# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 )
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
	if use static-libs; then
		emake PROCESSORS=$(makeopts_jobs) \
			GPRBUILD_OPTIONS=-v \
			build-static
	fi
	if use shared; then
		emake PROCESSORS=$(makeopts_jobs) \
			GPRBUILD_OPTIONS=-v \
			build-relocatable
	fi
	if use static-pic; then
		emake PROCESSORS=$(makeopts_jobs) \
			GPRBUILD_OPTIONS=-v \
			build-static-pic
	fi
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

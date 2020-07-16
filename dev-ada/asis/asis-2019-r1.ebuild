# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_201{7,8,9} )
inherit ada multiprocessing
MYP=${P}-20190517-18AB5-src

DESCRIPTION="To develop tools for Ada software"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf849031e87aa2cdf16b10
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-ada/gnat_util[${ADA_USEDEP}]
	dev-ada/gnatcoll-core[${ADA_USEDEP},shared]"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${PN}-2017-gentoo.patch )

src_compile() {
	emake PROCESSORS=$(makeopts_jobs) \
		GPRBUILD_FLAGS="-vl"
	emake tools PROCESSORS=$(makeopts_jobs) \
		GPRBUILD_FLAGS="-vl \
		-XGPR_BUILD=relocatable \
		-XLIBRARY_TYPE=relocatable \
		-XXMLADA_BUILD=relocatable"
}

src_install() {
	emake prefix="${D}"/usr install
	emake prefix="${D}"/usr install-tools \
		GPRINSTALL="gprinstall \
		-XGPR_BUILD=relocatable \
		-XLIBRARY_TYPE=relocatable \
		-XXMLADA_BUILD=relocatable"
	rm -r "${D}"/usr/share/gpr/manifests || die
	mv "${D}"/usr/bin/gnatpp{,-asis} || die
}

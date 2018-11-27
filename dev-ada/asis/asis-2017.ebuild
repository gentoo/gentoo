# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing
MYP=${PN}-gpl-${PV}-src

DESCRIPTION="To develop tools for Ada software"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deecffb
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnat_2016 +gnat_2017"

RDEPEND="dev-ada/gnat_util[gnat_2017]
	|| (
		dev-ada/gnatcoll-core[gnat_2017,shared]
		dev-ada/gnatcoll[gnat_2017,projects,shared]
	)"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[gnat_2017]"

REQUIRED_USE="!gnat_2016 gnat_2017"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

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
}

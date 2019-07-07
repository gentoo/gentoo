# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing
MYP=${P}-20190517-18AB5-src

DESCRIPTION="To develop tools for Ada software"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf849031e87aa2cdf16b10
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2017 gnat_2018 +gnat_2019"

RDEPEND="
	dev-ada/gnat_util[gnat_2017(-)?]
	dev-ada/gnat_util[gnat_2018(-)?,gnat_2019(-)?]
	|| (
		dev-ada/gnatcoll-core[gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?,shared]
		dev-ada/gnatcoll[gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?,projects,shared]
	)"
DEPEND="${RDEPEND}
dev-ada/gprbuild[gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?]"

REQUIRED_USE="|| ( gnat_2017 gnat_2018 gnat_2019 )"

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

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing
MYP=${PN}-gpl-${PV}-src

DESCRIPTION="To develop tools for Ada software"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/57399029c7a447658e0aff71
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gnat_2016 gnat_2017"

DEPEND="dev-ada/gnat_util[gnat_2016=,gnat_2017=]
	dev-ada/gnatcoll[gnat_2016=,gnat_2017=,projects,shared]
	dev-ada/gprbuild[gnat_2016=,gnat_2017=]
	dev-ada/xmlada[gnat_2016=,gnat_2017=]
	gnat_2016? ( dev-lang/gnat-gpl:4.9.4 )
	gnat_2017? ( dev-lang/gnat-gpl:6.3.0 )"
RDEPEND="${RDEPEND}"
REQUIRED_USE="^^ ( gnat_2016 gnat_2017 )"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	emake PROCESSORS=$(makeopts_jobs)
	emake tools PROCESSORS=$(makeopts_jobs) \
		GPRBUILD_FLAGS="-vl \
		-XLIBRARY_TYPE=relocatable \
		-XXMLADA_BUILD=relocatable"
}

src_install() {
	emake prefix="${D}"/usr install
	emake prefix="${D}"/usr install-tools \
		GPRINSTALL="gprinstall \
		-XLIBRARY_TYPE=relocatable \
		-XXMLADA_BUILD=relocatable"
}

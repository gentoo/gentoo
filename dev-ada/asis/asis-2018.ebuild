# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing
MYP=${PN}-gpl-${PV}-src

DESCRIPTION="To develop tools for Ada software"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819e0c7a447df26c27ab8
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 +gnat_2018"

DEPEND="dev-ada/gnat_util[gnat_2018]
	dev-ada/gnatcoll-core[gnat_2018,shared]
	dev-ada/gprbuild[gnat_2018]
	dev-ada/xmlada[gnat_2018]
	dev-lang/gnat-gpl:7.3.0"
RDEPEND="${RDEPEND}"
REQUIRED_USE="!gnat_2016 !gnat_2017 gnat_2018"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${PN}-2017-gentoo.patch )

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

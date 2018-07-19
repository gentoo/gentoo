# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing

MY_P=${PN}-gpl-${PV}-src

DESCRIPTION="A complete Web development framework"
HOMEPAGE="http://libre.adacore.com/tools/aws/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819e0c7a447df26c27abd
	-> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 +gnat_2018"

RDEPEND="dev-ada/xmlada[gnat_2016=,gnat_2017=,gnat_2018(-)=]
	dev-ada/xmlada[shared,static-libs]"
DEPEND="${RDEPEND}
	dev-ada/asis[gnat_2016=,gnat_2017=,gnat_2018(-)=]
	dev-ada/gprbuild[gnat_2016=,gnat_2017=,gnat_2018(-)=]"

S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-2016-gentoo.patch )

src_configure() {
	emake -j1 setup prefix=/usr ENABLE_SHARED=true
}

src_compile() {
	if use gnat_2018; then
		GCC_PV=7.3.1
	elif use gnat_2017; then
		GCC_PV=6.3.0
	else
		GCC_PV=4.9.4
	fi
	emake GCC=${CHOST}-gcc-${GCC_PV} \
		PROCESSORS=$(makeopts_jobs) \
		GPRBUILD="/usr/bin/gprbuild -v"
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}

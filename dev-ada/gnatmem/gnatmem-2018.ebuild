# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing autotools

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="Monitors dynamic allocation and deallocation activity in a program"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819dfc7a447df26c27a72 ->
	${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 +gnat_2018"

RDEPEND=""
DEPEND="dev-ada/gprbuild[gnat_2016=,gnat_2017=,gnat_2018=]"

REQUIRED_USE="^^ ( gnat_2016 gnat_2017 gnat_2018 )"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${PN}-2016-gentoo.patch )

src_prepare() {
	default
	mv configure.in configure.ac
	eautoreconf
}

src_compile() {
	if use gnat_2016; then
		GCC_PV=4.9.0
	elif use gnat_2017; then
		GCC_PV=6.3.0
	else
		GCC_PV=7.3.1
	fi
	gprbuild -v -Pgnatmem.gpr -j$(makeopts_jobs) -XCC=gcc-${GCC_PV} \
		-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS}
}

src_install() {
	dobin obj/gnatmem
}

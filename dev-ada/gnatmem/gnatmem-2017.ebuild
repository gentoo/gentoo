# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing autotools

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="Monitors dynamic allocation and deallocation activity in a program"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/591c45e2c7a447af2deed033 ->
	${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnat_2016 +gnat_2017"

RDEPEND=""
DEPEND="dev-ada/gprbuild[gnat_2016=,gnat_2017=]"

REQUIRED_USE="^^ ( gnat_2016 gnat_2017 )"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${PN}-2016-gentoo.patch )

src_prepare() {
	default
	mv configure.in configure.ac
	eautoreconf
}

src_compile() {
	gprbuild -Pgnatmem.gpr -j$(makeopts_jobs) \
		-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS}
}

src_install() {
	dobin obj/gnatmem
}

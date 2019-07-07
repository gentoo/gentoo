# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing autotools

MYP=${P}-20190429-19745-src

DESCRIPTION="Monitors dynamic allocation and deallocation activity in a program"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf8e1431e87a8f1d425089
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2016 gnat_2017 gnat_2018 +gnat_2019"

RDEPEND=""
DEPEND="dev-ada/gprbuild[gnat_2016(-)?,gnat_2017(-)?,gnat_2018(-)?,gnat_2019(-)?]
	sys-libs/binutils-libs"

REQUIRED_USE="^^ ( gnat_2016 gnat_2017 gnat_2018 gnat_2019 )"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${PN}-2018-gentoo.patch )

src_prepare() {
	default
	mv configure.in configure.ac
	eautoreconf
}

src_compile() {
	gprbuild -v -Pgnatmem.gpr -j$(makeopts_jobs) \
		-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS}
}

src_install() {
	dobin obj/gnatmem
}

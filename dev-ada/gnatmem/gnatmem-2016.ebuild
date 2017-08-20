# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing autotools

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="Monitors dynamic allocation and deallocation activity in a program"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/573995c8c7a447658e0affa2 -> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="dev-ada/gprbuild"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

pkg_setup() {
	GCC=${ADA:-$(tc-getCC)}
	export GNATBIND="${GCC/gcc/gnatbind}"
	if [[ -z "$(type ${GNATBIND} 2>/dev/null)" ]] ; then
		eerror "You need a gcc compiler that provides the Ada Compiler:"
		eerror "1) use gcc-config to select the right compiler or"
		eerror "2) set ADA=gcc-4.9.4 in make.conf"
		die "ada compiler not available"
	fi
}

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

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing autotools

MYP=${P}-20190429-19761-src

DESCRIPTION="Translates addresses into filename, line number, and function names"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cc7d5e431e87a23952f18c4 ->
	${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnat_2018 +gnat_2019"

RDEPEND=""
DEPEND="gnat_2018? ( dev-lang/gnat-gpl:7.3.1 )
	gnat_2019? ( dev-lang/gnat-gpl:8.3.1 )"
REQUIRED_USE=" ^^ ( gnat_2018 gnat_2019 )"

S="${WORKDIR}"/${MYP}

src_compile() {
	if use gnat_2018; then
		GCC_PV=7.3.1
	else
		GCC_PV=8.3.1
	fi
	gnatmake-${GCC_PV} -v gnatsymbolize -cargs ${ADAFLAGS} || die
}

src_install() {
	dobin gnatsymbolize
}

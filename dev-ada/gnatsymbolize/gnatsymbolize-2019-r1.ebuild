# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ADA_COMPAT=( gnat_201{8,9} )
inherit ada multiprocessing autotools

MYP=${P}-20190429-19761-src

DESCRIPTION="Translates addresses into filename, line number, and function names"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cc7d5e431e87a23952f18c4 ->
	${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}"
REQUIRED_USE="${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}

src_compile() {
	gnatmake -v gnatsymbolize -cargs ${ADAFLAGS} || die
}

src_install() {
	dobin gnatsymbolize
}

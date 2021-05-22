# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ADA_COMPAT=( gnat_201{8,9} gnat_2020 )
inherit ada multiprocessing autotools

MYP=${P}-20200429-19987-src

DESCRIPTION="Translates addresses into filename, line number, and function names"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cc7d5e431e87a23952f18c4 ->
	${MYP}.tar.gz"
SRC_URI="https://community.download.adacore.com/v1/ebef002ce60066e3befdd1a4a0980f3ab8f1b551?filename=${MYP}.tar.gz
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

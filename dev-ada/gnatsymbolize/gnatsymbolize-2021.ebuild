# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ADA_COMPAT=( gnat_201{8,9} gnat_202{0..1} )
inherit ada multiprocessing autotools

MYP=${P}-${PV}0518-19D3B-src
ID=884f3b229457c995ddebb46a16a7cc50ed837c90
ADAMIRROR=https://community.download.adacore.com/v1

DESCRIPTION="Translates addresses into filename, line number, and function names"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cc7d5e431e87a23952f18c4 ->
	${MYP}.tar.gz"
SRC_URI="${ADAMIRROR}/${ID}?filename=${MYP}.tar.gz -> ${MYP}.tar.gz"

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

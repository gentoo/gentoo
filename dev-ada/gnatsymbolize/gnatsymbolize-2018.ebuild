# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing autotools

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="Translates addresses into filename, line number, and function names"
HOMEPAGE="http://libre.adacore.com/"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0819dfc7a447df26c27a6d ->
	${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-lang/gnat-gpl:7.3.1"

S="${WORKDIR}"/${MYP}

src_compile() {
	gnatmake-7.3.1 -v gnatsymbolize -cargs ${ADAFLAGS} || die
}

src_install() {
	dobin gnatsymbolize
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

MY_P=${PN}_${PV}
DESCRIPTION="polymorphs bytecode to a printable ASCII string"
HOMEPAGE="http://www.securiteam.com/tools/5MP0L2KFPA.html"
SRC_URI="https://repo.palkeo.com/repositories/mirror7.meh.or.id/Tools/OTHER_TOOLS/ShellCode/${MY_P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-build.patch" )

src_compile() {
	emake CC="$(tc-getCC)" ${PN}
}

src_install() {
	dobin ${PN}
	dodoc ${PN}.txt
}

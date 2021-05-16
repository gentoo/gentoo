# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Graphical front end to the diff program"
HOMEPAGE="http://tkdiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-lang/tk"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-unix"

src_install() {
	dobin tkdiff
	dodoc CHANGELOG.txt
}

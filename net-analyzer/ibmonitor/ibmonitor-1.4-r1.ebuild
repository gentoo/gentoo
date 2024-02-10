# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Interactive bandwidth monitor"
HOMEPAGE="https://ibmonitor.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}"

KEYWORDS="~amd64 ~hppa ~ppc ~riscv x86"
LICENSE="GPL-2+"
SLOT="0"

RDEPEND="dev-perl/TermReadKey"

src_install() {
	dobin ibmonitor
	dodoc AUTHORS ChangeLog README TODO
}

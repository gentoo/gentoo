# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

S=${WORKDIR}/dlx

DESCRIPTION="DLX Simulator"
HOMEPAGE="https://www.davidviner.com/dlx"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

src_install() {
	dobin masm mon dasm
	dodoc README.txt MANUAL.TXT
}

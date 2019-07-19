# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

S=${WORKDIR}/dlx

DESCRIPTION="DLX Simulator"
HOMEPAGE="http://www.davidviner.com/dlx.php"
SRC_URI="http://www.davidviner.com/dlx/dlx.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

src_install() {
	dobin masm mon dasm
	dodoc README.txt MANUAL.TXT
}

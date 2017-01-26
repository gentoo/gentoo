# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="Laptop power measuring tool"
EGIT_REPO_URI=(
	"git://kernel.ubuntu.com/cking/${PN}.git"
	"https://github.com/ColinIanKing/${PN}.git"
	)
HOMEPAGE="https://launchpad.net/ubuntu/+source/${PN} https://github.com/ColinIanKing/${PN}"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

src_compile() {
	emake CC=$(tc-getCC)
}

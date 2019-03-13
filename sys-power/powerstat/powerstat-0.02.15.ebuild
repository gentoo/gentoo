# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Laptop power measuring tool"
HOMEPAGE="https://launchpad.net/ubuntu/+source/${PN} https://github.com/ColinIanKing/${PN}"
SRC_URI="https://github.com/ColinIanKing/${PN}/archive/V${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	emake CC=$(tc-getCC)
}

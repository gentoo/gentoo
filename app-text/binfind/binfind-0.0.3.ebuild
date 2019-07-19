# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="binfind searches files for a byte sequence specified on the command line"
HOMEPAGE="http://www.lith.at/binfind"
SRC_URI="http://www.lith.at/binfind/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README ChangeLog
}

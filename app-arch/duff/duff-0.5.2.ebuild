# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Command-line utility for quickly finding duplicates in a given set of files"
HOMEPAGE="http://duff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog HACKING NEWS README* TODO
}

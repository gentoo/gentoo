# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="blinkentools is a set of commandline utilities related to Blinkenlights"
HOMEPAGE="http://blinkenlights.net/project/developer-tools"
SRC_URI="http://blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="media-libs/blib
	media-libs/libmng
	virtual/pkgconfig"
RDEPEND=""

src_compile() {
	econf
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}

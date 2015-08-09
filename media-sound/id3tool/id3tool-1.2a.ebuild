# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A command line utility for easy manipulation of the ID3 tags present in MPEG Layer 3 audio files"
HOMEPAGE="http://nekohako.xware.cx/id3tool"
SRC_URI="http://nekohako.xware.cx/id3tool/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm amd64 ~ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc CHANGELOG README
}

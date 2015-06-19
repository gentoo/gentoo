# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/id3tool/id3tool-1.2a.ebuild,v 1.7 2012/12/16 19:27:25 ulm Exp $

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

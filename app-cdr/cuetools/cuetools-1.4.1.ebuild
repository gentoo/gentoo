# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Utilities to manipulate and convert cue and toc files"
HOMEPAGE="https://github.com/svend/cuetools"
SRC_URI="https://github.com/svend/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="flac mp3 vorbis"

RDEPEND="
	flac? ( media-libs/flac )
	mp3? ( media-sound/mp3info )
	vorbis? ( media-sound/vorbis-tools )
"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README.md TODO
	docinto extras
	dodoc extras/{cueconvert.cgi,*.txt}
}

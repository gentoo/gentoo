# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Utilities to manipulate and convert cue and toc files"
HOMEPAGE="http://developer.berlios.de/projects/cuetools/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-debian.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="extras"

DEPEND="sys-devel/bison
	sys-devel/flex"
RDEPEND="extras? (
		media-sound/vorbis-tools
		media-libs/flac
		media-sound/mp3info
	)"

src_prepare() {
	epatch "${WORKDIR}"/${P}-debian.patch \
		"${FILESDIR}"/${P}-flac.patch
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README TODO
	use extras && dobin extras/cuetag.sh
	docinto extras
	dodoc extras/{cueconvert.cgi,*.txt}
}

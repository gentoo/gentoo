# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="A perl script to convert Ogg Vorbis files to MP3 files"
HOMEPAGE="http://www.gitorious.org/ogg2mp3/pages/Home"
SRC_URI="http://www.jamesa.com/projects/ogg2mp3/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-sound/lame
	dev-perl/String-ShellQuote
	media-sound/vorbis-tools[ogg123]"
DEPEND=""

src_install() {
	dobin ogg2mp3 || die "dobin failed"
	dodoc doc/{AUTHORS,ChangeLog,README,TODO}
}

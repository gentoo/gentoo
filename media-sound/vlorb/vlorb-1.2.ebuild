# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A high quality Audio CD to audio file encoder"
HOMEPAGE="http://jk.yazzy.org/projects/vlorb/"
SRC_URI="http://jk.yazzy.org/projects/vlorb/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="ogg"

RDEPEND="
	dev-lang/perl
	dev-perl/CDDB
	media-sound/cdparanoia
	ogg? ( media-sound/vorbis-tools )"

src_compile() { :; }

src_install() {
	dobin vlorb

	einstalldocs
	doman vlorb.1
}

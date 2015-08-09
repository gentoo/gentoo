# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Jason's Image Gallery"
HOMEPAGE="http://xome.net/projects/jigl/"
SRC_URI="http://xome.net/projects/jigl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/perl
	media-gfx/jhead
	media-gfx/imagemagick"
DEPEND=""

src_install() {
	newbin jigl.pl jigl || die
	dodoc ChangeLog Themes Todo
}

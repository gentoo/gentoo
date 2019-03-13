# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Jason's Image Gallery"
HOMEPAGE="http://xome.net/projects/jigl/"
SRC_URI="http://xome.net/projects/jigl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	media-gfx/jhead
	virtual/imagemagick-tools
"
DEPEND=""

src_install() {
	newbin jigl.pl jigl
	dodoc ChangeLog Themes Todo
}

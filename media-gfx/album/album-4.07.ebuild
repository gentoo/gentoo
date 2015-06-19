# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/album/album-4.07.ebuild,v 1.3 2012/09/30 18:05:38 armin76 Exp $

EAPI=4

DESCRIPTION="HTML photo album generator"
HOMEPAGE="http://MarginalHacks.com/Hacks/album/"
SRC_URI="http://marginalhacks.com/bin/album.versions/${P}.tar.gz
	http://marginalhacks.com/bin/album.versions/data-4.05.tar.gz"

LICENSE="marginalhacks"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc ffmpeg plugins themes"

DEPEND=""
RDEPEND="dev-lang/perl
	media-gfx/imagemagick
	media-gfx/jhead
	ffmpeg? ( virtual/ffmpeg )"

src_install() {
	dobin album
	doman album.1
	dodoc License.txt CHANGELOG
	use doc && dohtml -r Docs/*

	dodir /usr/share/album
	insinto /usr/share/album
	cd ..
	doins -r lang
	use themes && doins -r Themes
	use plugins && doins -r plugins
}

pkg_postinst() {
	elog "For some optional tools please browse:"
	elog "http://MarginalHacks.com/Hacks/album/tools/"
}

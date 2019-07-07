# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

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
	media-gfx/jhead
	virtual/imagemagick-tools
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

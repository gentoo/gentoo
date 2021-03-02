# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="HTML photo album generator"
HOMEPAGE="https://marginalhacks.com/Hacks/album/"
SRC_URI="https://marginalhacks.com/bin/album.versions/${P}.tar.gz
	https://marginalhacks.com/bin/album.versions/data-4.05.tar.gz"

LICENSE="marginalhacks"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc ffmpeg plugins themes"

DEPEND=""
RDEPEND="dev-lang/perl
	media-gfx/jhead
	virtual/imagemagick-tools
	ffmpeg? ( media-video/ffmpeg )"

src_install() {
	dobin album
	doman album.1
	dodoc License.txt CHANGELOG

	if use doc ; then
		docinto html
		dodoc -r Docs/.
	fi

	dodir /usr/share/album
	insinto /usr/share/album
	cd .. || die
	doins -r lang
	use themes && doins -r Themes
	use plugins && doins -r plugins
}

pkg_postinst() {
	elog "For some optional tools please browse:"
	elog "https://MarginalHacks.com/Hacks/album/tools/"
}

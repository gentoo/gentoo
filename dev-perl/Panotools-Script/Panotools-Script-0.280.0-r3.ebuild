# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BPOSTLE
DIST_VERSION=0.28
inherit eutils perl-module

DESCRIPTION="A perl module for reading, writing, and manipulating hugin script files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

RDEPEND="dev-perl/URI
	dev-perl/libwww-perl
	>=dev-perl/Image-Size-2.900.0
	>=media-libs/exiftool-6
	gui? ( gnome-extra/zenity )"
DEPEND=""
PATCHES=( "${FILESDIR}/${PN}-0.28-curly-bracket.patch" )

src_install() {
	perl-module_src_install
	if use gui ; then
		domenu "${S}"/desktop/*.desktop || die
	else
		rm "${D}"/usr/bin/*-gui || die
	fi
}

pkg_postinst() {
	einfo "Some of the scripts require 'nona', 'freepv', 'enblend', 'autotrace', and"
	einfo "ImageMagick command-line tools which are available in the following"
	einfo "packages: media-gfx/hugin, media-gfx/freepv, media-gfx/enblend,"
	einfo "media-gfx/autotrace, and media-gfx/imagemagick."
}

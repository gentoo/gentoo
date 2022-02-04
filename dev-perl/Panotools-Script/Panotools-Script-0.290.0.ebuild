# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPOSTLE
DIST_VERSION=0.29
inherit desktop perl-module

DESCRIPTION="A perl module for reading, writing, and manipulating hugin script files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

RDEPEND="
	>=virtual/perl-File-Spec-0.800.0
	>=virtual/perl-File-Temp-0.100.0
	>=virtual/perl-Getopt-Long-2.0.0
	dev-perl/URI
	dev-perl/libwww-perl
	>=dev-perl/Image-Size-2.900.0
	>=media-libs/exiftool-6
	gui? ( gnome-extra/zenity )
"
BDEPEND="${RDEPEND}
"

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

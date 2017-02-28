# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Data visualization application for astronomical FITS images"
HOMEPAGE="http://ds9.si.edu/site/Home.html"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/ds9.png.tar
	amd64? ( http://ds9.si.edu/download/linux64/ds9.linux64.${PV}.tar.gz )
	x86? ( http://hea-www.harvard.edu/RD/ds9/download/linux/ds9.linux.${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""

RDEPEND="
	dev-libs/libxml2
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/xpa"

DEPEND=""
S="${WORKDIR}"

QA_PRESTRIPPED="usr/bin/ds9"
QA_PREBUILT="usr/bin/ds9"

src_install () {
	dobin ds9
	doicon ds9.png
	make_desktop_entry ds9 "SAOImage DS9" ds9
}

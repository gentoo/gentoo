# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a nice digital clock with 7 different styles either in LCD or LED style"
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"
SRC_URI="mirror://debian/pool/main/w/${PN}/${PN}_${PV}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"

RDEPEND="x11-libs/gtk+:2
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libICE"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
	x11-libs/libXt"

PATCHES=( "${FILESDIR}"/${P}-gtk.patch
	"${FILESDIR}"/${P}-gcc-10.patch )

DOCS=( AUTHORS BUGS ChangeLog NEWS README THANKS TODO \
	doc/sample2.wmclockmonrc doc/sample1.wmclockmonrc )

src_install() {
	default
	newdoc debian/changelog ChangeLog.debian
}

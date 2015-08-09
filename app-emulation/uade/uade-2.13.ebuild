# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Unix Amiga Delitracker Emulator - plays old Amiga tunes through UAE emulation"
HOMEPAGE="http://zakalwe.fi/uade"
SRC_URI="http://zakalwe.fi/uade/uade2/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-libs/libao"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	./configure \
		--prefix=/usr \
		--package-prefix="${D}" \
		--with-uade123 \
		--with-text-scope \
		--without-xmms \
		--without-audacious || die
}

src_install() {
	DOCS="AUTHORS ChangeLog doc/BUGS doc/PLANS" \
		default
	doman doc/uade123.1
}

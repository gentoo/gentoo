# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/uade/uade-2.13.ebuild,v 1.7 2015/03/23 07:39:41 mr_bones_ Exp $

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

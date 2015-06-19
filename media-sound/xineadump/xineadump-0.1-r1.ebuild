# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/xineadump/xineadump-0.1-r1.ebuild,v 1.1 2009/07/05 16:00:11 ssuominen Exp $

EAPI=2
inherit eutils

DESCRIPTION="Utility for Xine decoding support in transKode"
HOMEPAGE="http://sourceforge.net/projects/transkode"
SRC_URI="mirror://sourceforge/transkode/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-libs/xine-lib
	media-libs/alsa-lib"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-4.3.patch \
		"${FILESDIR}"/${P}-gcc-4.4.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS
}

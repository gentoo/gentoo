# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libg15render/libg15render-1.2-r2.ebuild,v 1.1 2011/09/09 16:51:21 scarabeus Exp $

EAPI=4

inherit eutils

DESCRIPTION="Small library for display text and graphics on a Logitech G15 keyboard"
HOMEPAGE="http://g15tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/g15tools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

IUSE="truetype"

RDEPEND="
	dev-libs/libg15
	truetype? ( media-libs/freetype )
"
DEPEND=${RDEPEND}

src_prepare() {
	epatch "${FILESDIR}/${P}-pixel-c.patch"
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable truetype ttf )
}

src_install() {
	emake DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} install || die "make install failed"
	rm "${ED}/usr/share/doc/${PF}/COPYING"

	find "${ED}" -name '*.la' -exec rm -f {} +
}

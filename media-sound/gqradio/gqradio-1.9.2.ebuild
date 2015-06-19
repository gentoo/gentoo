# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gqradio/gqradio-1.9.2.ebuild,v 1.7 2014/08/10 21:06:29 slyfox Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="An FM radio tuner app from the people who brought you GQmpeg"
HOMEPAGE="http://gqmpeg.sourceforge.net/radio.html"
SRC_URI="mirror://sourceforge/gqmpeg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4:2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog README SKIN-SPECS TODO"

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
	eautoreconf
}

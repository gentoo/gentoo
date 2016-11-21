# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Diagnosis tool for JACK audio software"
HOMEPAGE="http://devel.tlrmx.org/audio/"
SRC_URI="http://devel.tlrmx.org/audio/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

RDEPEND="
	media-sound/jack-audio-connection-kit
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare(){
	default
	# fix desktop file
	sed -e "/^Terminal/ s/0/false/" \
		-e "/^Icon/ s/\.xpm//" \
		-e "/^Categories/ s/Application;//" \
		-i bitmeter.desktop || die

	append-libs -lm # bug 586148
	eautoreconf
}

src_install() {
	use doc && HTML_DOCS=( doc/{*.png,*.html} )
	default
}

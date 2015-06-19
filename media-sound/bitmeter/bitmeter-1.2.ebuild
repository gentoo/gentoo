# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bitmeter/bitmeter-1.2.ebuild,v 1.8 2012/05/05 08:10:23 mgorny Exp $

EAPI=2

DESCRIPTION="a diagnosis tool for JACK audio software"
HOMEPAGE="http://users.ecs.soton.ac.uk/njl98r/code/audio/bitmeter"
SRC_URI="http://users.ecs.soton.ac.uk/njl98r/code/audio/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

RDEPEND="media-sound/jack-audio-connection-kit
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	!media-sound/bitscope"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc README
	use doc && dohtml doc/{*.png,*.html}
}

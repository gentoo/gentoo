# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xsynth-dssi/xsynth-dssi-0.9.4.ebuild,v 1.2 2012/05/05 08:27:19 jdhore Exp $

DESCRIPTION="A software synthesizer plugin for the DSSI Soft Synth Interface"
HOMEPAGE="http://dssi.sourceforge.net/download.html#Xsynth-DSSI"
SRC_URI="mirror://sourceforge/dssi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=x11-libs/gtk+-2*
	media-libs/alsa-lib
	>=media-libs/dssi-0.9
	>=media-libs/liblo-0.12"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO
}

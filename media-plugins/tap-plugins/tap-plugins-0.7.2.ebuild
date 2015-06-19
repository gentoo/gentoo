# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/tap-plugins/tap-plugins-0.7.2.ebuild,v 1.5 2012/10/14 18:28:47 armin76 Exp $

EAPI=4

inherit multilib toolchain-funcs eutils

IUSE=""

DESCRIPTION="TAP LADSPA plugins package. Contains DeEsser, Dynamics, Equalizer, Reverb, Stereo Echo, Tremolo"
HOMEPAGE="http://tap-plugins.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.7.0-cflags-ldflags.patch"
}

src_compile() {
	emake CC=$(tc-getCC) OPT_CFLAGS="${CFLAGS}" EXTRA_LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodoc README CREDITS
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
	insinto /usr/share/ladspa/rdf
	insopts -m0644
	doins *.rdf
}

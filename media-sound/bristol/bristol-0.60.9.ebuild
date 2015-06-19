# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bristol/bristol-0.60.9.ebuild,v 1.6 2012/05/05 08:16:22 mgorny Exp $

EAPI="4"

inherit eutils autotools-utils

DESCRIPTION="Synthesizer keyboard emulation package: Moog, Hammond and others"
HOMEPAGE="http://sourceforge.net/projects/bristol"
SRC_URI="mirror://sourceforge/bristol/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa oss static-libs"
# osc : configure option but no code it seems...
# jack: fails to build if disabled

RDEPEND=">=media-sound/jack-audio-connection-kit-0.109.2
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	x11-libs/libX11"
# osc? ( >=media-libs/liblo-0.22 )
DEPEND="${RDEPEND}
	x11-proto/xproto
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog HOWTO NEWS README )

PATCHES=( "${FILESDIR}"/${P}-cflags.patch )

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-version-check
		$(use_enable alsa)
		$(use_enable oss)
		#$(use_enable osc liblo)
	)
	autotools-utils_src_configure
}

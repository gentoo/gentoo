# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sidplayfp/sidplayfp-1.1.0.ebuild,v 1.1 2013/10/01 15:14:47 ssuominen Exp $

EAPI=5
inherit eutils

DESCRIPTION="A sidplay2 fork with resid-fp"
HOMEPAGE="http://sourceforge.net/projects/sidplay-residfp/"
SRC_URI="mirror://sourceforge/sidplay-residfp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa oss pulseaudio"

RDEPEND=">=media-libs/libsidplayfp-1.1.0
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	oss? ( virtual/os-headers )"

DOCS=( AUTHORS README TODO )

src_prepare() {
	use alsa || { sed -i -e 's:alsa >= 1.0:dIsAbLe&:' configure || die; }
	use pulseaudio || { sed -i -e 's:libpulse-simple >= 1.0:dIsAbLe&:' configure || die; }
}

src_configure() {
	export ac_cv_header_linux_soundcard_h=$(usex oss)
	econf
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sidplayfp/sidplayfp-0.3.3.ebuild,v 1.1 2012/12/16 16:19:42 ssuominen Exp $

EAPI=5

DESCRIPTION="A sidplay2 fork with resid-fp"
HOMEPAGE="http://sourceforge.net/projects/sidplay-residfp/"
SRC_URI="mirror://sourceforge/sidplay-residfp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa oss pulseaudio"

RDEPEND=">=media-libs/libsidplayfp-0.3.8
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	oss? ( virtual/os-headers )"

DOCS=( AUTHORS ChangeLog README TODO )

src_configure() {
	local output=wav
	use oss && output=oss
	use alsa && output=alsa
	use pulseaudio && output=pulse

	econf --enable-driver=${output}
}

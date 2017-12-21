# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A virtual MIDI keyboard for JACK MIDI"
HOMEPAGE="http://pin.if.uz.zgora.pl/~trasz/jack-keyboard/"
SRC_URI="http://pin.if.uz.zgora.pl/~trasz/jack-keyboard/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="lash X"

RDEPEND="virtual/jack
	>=x11-libs/gtk+-2.12:2
	>=dev-libs/glib-2.2:2
	lash? ( media-sound/lash )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-apps/sed"

src_configure() {
	econf $(use_with X x11) \
		$(use_with lash)
}

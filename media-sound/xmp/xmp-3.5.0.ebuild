# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Extended Module Player"
HOMEPAGE="http://xmp.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa audacious nas oss pulseaudio"

RDEPEND="alsa? ( media-libs/alsa-lib )
	audacious? ( media-sound/audacious )
	nas? ( media-libs/nas )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	oss? ( virtual/os-headers )"

src_configure() {
	econf \
		$(use_enable oss) \
		$(use_enable alsa) \
		$(use_enable nas) \
		$(use_enable pulseaudio) \
		$(use_enable audacious audacious-plugin)
}

src_install() {
	default

	doman docs/xmp.1
	rm -f docs/{COPYING,Makefile,xmp.1}
	dodoc -r docs/*
}

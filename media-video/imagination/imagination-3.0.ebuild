# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit autotools eutils

DESCRIPTION="Simple DVD slideshow maker"
HOMEPAGE="http://imagination.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/gtk+:2
	media-sound/sox"
RDEPEND="${DEPEND}
	virtual/ffmpeg"

LANGS="cs de en_GB fr it pt_BR sv zh_CN zh_TW"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch
	eautoreconf
}

src_install() {
	default
	doicon icons/48x48/${PN}.png
}

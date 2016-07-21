# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools eutils

DESCRIPTION="Simple DVD slideshow maker"
HOMEPAGE="http://imagination.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_cs linguas_de linguas_en_GB linguas_fr linguas_it linguas_pt_BR
linguas_sv linguas_zh_CN linguas_zh_TW"

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

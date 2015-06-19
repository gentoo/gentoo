# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/imagination/imagination-3.0-r1.ebuild,v 1.2 2012/03/14 08:41:06 hwoarang Exp $

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
	# enable translations. Bug #380011
	sed -i -e "/#define PLUGINS_INSTALLED/s:0:1:" "${S}"/src/support.h || die
	rm "${S}"/po/LINGUAS
	for x in ${LANGS}; do
		if ! has ${x} ${LINGUAS}; then
			rm "${S}"/po/${x}.po || die
		else
			echo -n "${x} " >> "${S}"/po/LINGUAS
		fi
	done
	eautoreconf
}

src_install() {
	default
	doicon icons/48x48/${PN}.png
}

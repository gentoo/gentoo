# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="Precise Instrument Tweaking for Crispy Harmony - tuner"
HOMEPAGE="https://sourceforge.net/projects/pitchtune/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	media-libs/alsa-lib
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"

DOCS=( AUTHORS README REQUIRED TODO )
PATCHES=(
	"${FILESDIR}"/${PN}-0.0.4-lm.patch
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	doicon pixmaps/${PN}.xpm
	make_desktop_entry ${PN} Pitchtune
}

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="Precise Instrument Tweaking for Crispy Harmony - tuner"
HOMEPAGE="http://sourceforge.net/projects/pitchtune/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	media-libs/alsa-lib"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	doicon pixmaps/${PN}.xpm
	make_desktop_entry ${PN} Pitchtune
	dodoc AUTHORS README REQUIRED TODO
}

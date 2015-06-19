# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-clock/vdr-clock-1.0.0-r1.ebuild,v 1.3 2013/03/25 20:41:34 ago Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Tea clock, clock"
HOMEPAGE="http://vdr.aistleitner.info"
SRC_URI="http://vdr.aistleitner.info/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.5.9"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}_gettext.diff"

	vdr-plugin-2_src_prepare
}

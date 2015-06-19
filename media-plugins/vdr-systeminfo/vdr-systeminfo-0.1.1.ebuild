# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-systeminfo/vdr-systeminfo-0.1.1.ebuild,v 1.2 2014/02/23 21:22:54 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: systeminfo"
HOMEPAGE="http://firefly.vdr-developer.org/systeminfo/"
SRC_URI="http://firefly.vdr-developer.org/systeminfo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.4.7"

RDEPEND="sys-apps/lm_sensors
		app-admin/hddtemp"

src_install() {
	vdr-plugin-2_src_install

	insinto /usr/share/vdr/systeminfo/
	insopts -m0755
	doins "${FILESDIR}"/systeminfo.sh
}

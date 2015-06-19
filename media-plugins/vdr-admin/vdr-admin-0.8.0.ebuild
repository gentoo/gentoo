# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-admin/vdr-admin-0.8.0.ebuild,v 1.5 2014/08/10 21:06:00 slyfox Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Admin OSD - This is not! the webadmin program called vdradmin"
HOMEPAGE="http://htpc-forum.de"
SRC_URI="mirror://vdrfiles/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.37"
RDEPEND="${DEPEND}"

S=${WORKDIR}/admin-${PV}

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i "s:/etc/vdr/plugins/admin:/usr/share/vdr/admin/bin:" gentoo/admin.conf
	sed -i "s:/etc/conf.d/vdr.admin.cfg:/usr/lib/vdr/rcscript/plugin-admin.sh:" gentoo/{runvdr,*.sh}
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/admin
	doins gentoo/admin.conf

	exeinto /usr/share/vdr/admin/bin
	doexe gentoo/{runvdr,*.sh}

	dodoc gentoo/vdr
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	ewarn
	ewarn "This plugin is not changed to support gentoo-vdr-scripts."
	ewarn "So it may not work without large config changes"
	ewarn
	ewarn "There are more config Parameter than default are in /etc/conf.d/vdr"
	ewarn "Find examples in /usr/share/doc/${PF}"
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit vdr-plugin-2

VERSION="1379" # every bump, new version

DESCRIPTION="VDR plugin: enable/disable parentalrating in records"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-${VDRPLUGIN}"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"
KEYWORDS="~amd64 ~x86"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0.2-r1[pinplugin]"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i "s:INCLUDES += -I\$(VDRINCDIR):INCLUDES += -I\$(VDRDIR)/include:" Makefile
}

src_install() {
	vdr-plugin-2_src_install

	dobin fskcheck

	insinto /usr/share/vdr/plugins/${VDRPLUGIN}
	doins "${S}"/scripts/fskprotect.sh

	insinto /usr/share/vdr/record
	newins "${S}"/scripts/cut.sh 20-preserve-pin-after-cut.sh

	insinto /etc/vdr/reccmds
	doins "${FILESDIR}"/reccmds.pin.conf
}

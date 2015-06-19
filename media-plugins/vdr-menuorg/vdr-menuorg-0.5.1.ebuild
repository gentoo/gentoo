# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-menuorg/vdr-menuorg-0.5.1.ebuild,v 1.1 2013/03/31 18:10:02 hd_brummy Exp $

EAPI="5"

inherit vdr-plugin-2

VERSION="1312" # every bump, new version

DESCRIPTION="VDR plugin: make osd menu configurable via config-file"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-menuorg"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0[menuorg]
	dev-cpp/libxmlpp:2.6
	dev-cpp/glibmm"
RDEPEND="${DEPEND}"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/menuorg
	doins menuorg.xml
}

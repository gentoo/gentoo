# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

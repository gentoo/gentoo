# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

VERSION="1881" # every bump, new version

DESCRIPTION="VDR Plugin: Osd-Teletext displays the teletext on the OSD"
HOMEPAGE="http://projects.vdr-developer.org/projects/show/plg-osdteletext"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.7.39"
RDEPEND="${DEPEND}"

VDR_RCADDON_FILE="${FILESDIR}/rc-addon-v3.sh"
VDR_CONFD_FILE="${FILESDIR}/confd-v2"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/sudoers.d
	insopts -m440
	newins "${FILESDIR}/vdr-osdteletext.sudo" vdr-osdteletext
}

# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

VERSION="1318" # every bump new version

DESCRIPTION="VDR Plugin: browse fast the EPG information without being to switch to a channel"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-zappilot"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.7.34"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-2.3.1"; then
		eapply "${FILESDIR}/${P}_vdr-2.3.1.patch"
	fi
}

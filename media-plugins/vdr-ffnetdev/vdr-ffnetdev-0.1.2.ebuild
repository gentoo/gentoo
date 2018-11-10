# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vdr-plugin-2

VERSION="837" # every bump, new version

DESCRIPTION="VDR Plugin: Output device which offers OSD via VNC and Video as raw mpeg over network"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-ffnetdev"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${P}

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}_gettext.diff"

	vdr-plugin-2_src_prepare
}

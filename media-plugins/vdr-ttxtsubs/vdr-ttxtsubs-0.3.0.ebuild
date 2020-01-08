# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

VERSION="1281" # every bump, new version!

DESCRIPTION="VDR Plugin: displaying, recording and replaying teletext based subtitles"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-ttxtsubs"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.7.38[ttxtsubs]"
RDEPEND="${DEPEND}"

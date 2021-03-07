# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

VERSION="932" # every bump, new version

MY_P=${PN}-$(ver_rs 3 -jw ${PV})

DESCRIPTION="VDR plugin: use LCD device for additional output"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-lcdproc"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${MY_P}.tgz -> ${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=app-misc/lcdproc-0.4.3
		>=media-video/vdr-2.4"

PATCHES=( "${FILESDIR}/vdr-2.4_lcdproc-0.0.10.9.patch" )

S=${WORKDIR}/${MY_P#vdr-}

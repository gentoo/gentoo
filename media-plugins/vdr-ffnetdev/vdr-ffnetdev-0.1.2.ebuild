# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

VERSION="837" # every bump, new version

DESCRIPTION="VDR Plugin: Provides an easy way of connecting possible streaming clients to VDR"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-ffnetdev"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tar.bz2"
S="${WORKDIR}/${P}" # override eclass default

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}_gettext.diff" )

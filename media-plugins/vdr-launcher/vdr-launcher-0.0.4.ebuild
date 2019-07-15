# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: launch other plugins - even when their menu-entry is hidden"
HOMEPAGE="http://people.freenet.de/cwieninger/html/vdr-launcher.html"
SRC_URI="http://winni.vdr-developer.org/launcher/downloads/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.7"
RDEPEND="${DEPEND}"

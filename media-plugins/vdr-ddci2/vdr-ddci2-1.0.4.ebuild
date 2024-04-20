# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jasmin-j/vdr-plugin-${VDRPLUGIN}.git"
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/jasmin-j/vdr-plugin-${VDRPLUGIN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/vdr-plugin-${VDRPLUGIN}-${PV}"
fi

DESCRIPTION="VDR plugin: DDCI2 - Digital Devices CI support"
HOMEPAGE="https://github.com/jasmin-j/vdr-plugin-ddci2"

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=media-video/vdr-2.1.7"
RDEPEND="${DEPEND}"

DOCS="COPYING HISTORY README"

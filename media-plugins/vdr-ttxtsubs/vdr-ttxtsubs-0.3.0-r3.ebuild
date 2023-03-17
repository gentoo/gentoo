# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: displaying, recording and replaying teletext based subtitles"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-ttxtsubs"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-ttxtsubs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tgz"
S="${WORKDIR}/vdr-plugin-ttxtsubs-${PV}"

KEYWORDS="~amd64 ~arm x86"
SLOT="0"
LICENSE="GPL-2+"
IUSE=""

DEPEND="media-video/vdr[ttxtsubs]"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	eapply "${FILESDIR}/${P}_teletext-chars.patch"

	if has_version ">=media-video/vdr-2.4"; then
		eapply "${FILESDIR}/${P}_vdr-2.4.0.patch"
	fi
}

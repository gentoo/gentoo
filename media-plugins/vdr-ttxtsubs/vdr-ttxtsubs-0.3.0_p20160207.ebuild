# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

GIT_COMMIT="ac89f6a027bf2cecafe376dd9deef7cfd80c0ac3"
MY_P="vdr-plugin-ttxtsubs-${GIT_COMMIT}"
DESCRIPTION="VDR Plugin: displaying, recording and replaying teletext based subtitles"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-ttxtsubs"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-ttxtsubs/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

DEPEND="media-video/vdr:=[ttxtsubs]"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-2.4"; then
		eapply "${FILESDIR}/${PN}-0.3.0_vdr-2.4.0.patch"
	fi
}

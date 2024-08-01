# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Control the vol level of diff controls of your soundcard"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-sndctl"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tar.gz"
S="${WORKDIR}/${VDRPLUGIN}-0.1.5-1"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-1.4.1
		media-libs/alsa-lib"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i sndctl.c -e "s:RegisterI18n://RegisterI18n:"
}

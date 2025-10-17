# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

# last version was imported to github without adding a release or tag
GIT_COMMIT="42b1bc7e45377e379fb1472f0c0affbb5ac5770c"
MY_P="vdr-plugin-sndctl-${GIT_COMMIT}"
DESCRIPTION="VDR plugin: Control the vol level of diff controls of your soundcard"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-sndctl"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-sndctl/archive/${GIT_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-video/vdr:=
	media-libs/alsa-lib"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i sndctl.c -e "s:RegisterI18n://RegisterI18n:" || die
}

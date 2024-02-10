# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: show background image for radio and decode RDS Text"
HOMEPAGE="https://projects.vdr-developer.org/projects/vdr-plugin-radio"
SRC_URI="https://projects.vdr-developer.org/git/vdr-plugin-radio.git/snapshot/vdr-plugin-radio-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="media-video/vdr"
DEPEND="${RDEPEND}"

S="${WORKDIR}/vdr-plugin-radio-${PV}"

src_install() {
	vdr-plugin-2_src_install

	cd "${S}"/config || die "Can't enter source folder"

	insinto /usr/share/vdr/radio
	doins mpegstill/rtext*
	dosym rtextOben-kleo2-live.mpg /usr/share/vdr/radio/radio.mpg
	dosym rtextOben-kleo2-replay.mpg /usr/share/vdr/radio/replay.mpg

	exeinto /usr/share/vdr/radio
	doexe scripts/radioinfo*
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: show background image for radio and decode RDS Text"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-radio/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-radio/archive/refs/tags/${PV}.tar.gz -> ${P}.tgz"
S="${WORKDIR}/vdr-plugin-radio-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e '/^CXXFLAGS +=/ s/$/ -std=c++14/' -i Makefile || die
	vdr-plugin-2_src_prepare
}

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

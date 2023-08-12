# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="FastTracker 2 inspired music tracker"
HOMEPAGE="https://milkytracker.titandemo.org/"
SRC_URI="https://github.com/milkytracker/MilkyTracker/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/MilkyTracker-${PV}"

LICENSE="|| ( GPL-3 MPL-1.1 ) AIFFWriter.m BSD GPL-3 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="alsa jack"

RDEPEND="
	dev-libs/zziplib
	media-libs/libsdl2[X]
	sys-libs/zlib
	alsa? (
		media-libs/alsa-lib
		media-libs/rtmidi
	)
	jack? ( virtual/jack )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-wreturn-type.patch
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package alsa ALSA)
		$(cmake_use_find_package jack JACK)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newicon resources/pictures/carton.png ${PN}.png
	make_desktop_entry ${PN} MilkyTracker ${PN} \
		"AudioVideo;Audio;Sequencer"
}

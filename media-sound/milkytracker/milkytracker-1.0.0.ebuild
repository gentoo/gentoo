# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils vcs-snapshot

DESCRIPTION="FastTracker 2 inspired music tracker"
HOMEPAGE="http://milkytracker.titandemo.org/"
SRC_URI="https://github.com/milkytracker/MilkyTracker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-3 MPL-1.1 ) AIFFWriter.m BSD GPL-3 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack"

RDEPEND="
	dev-libs/zziplib
	media-libs/libsdl2[X]
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.0.0-docdir.patch )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}
		$(cmake-utils_use_find_package alsa ALSA)
		$(cmake-utils_use_find_package jack JACK)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newicon resources/pictures/carton.png ${PN}.png
	make_desktop_entry ${PN} MilkyTracker ${PN} \
		"AudioVideo;Audio;Sequencer"
}

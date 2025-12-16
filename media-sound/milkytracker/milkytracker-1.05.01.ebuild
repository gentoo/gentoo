# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic xdg

DESCRIPTION="FastTracker 2 inspired music tracker"
HOMEPAGE="https://milkytracker.titandemo.org/"
SRC_URI="https://github.com/milkytracker/MilkyTracker/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/MilkyTracker-${PV}"

LICENSE="|| ( GPL-3 MPL-1.1 ) AIFFWriter.m BSD GPL-3 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="alsa jack"

RDEPEND="
	dev-libs/zziplib
	media-libs/libsdl2[X]
	virtual/zlib:=
	alsa? (
		media-libs/alsa-lib
		media-libs/rtmidi
	)
	jack? ( virtual/jack )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.04.00-cxx-std.patch
	"${FILESDIR}"/${P}-cmake4.patch # bug 957762
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/860870
	# https://github.com/milkytracker/MilkyTracker/issues/340
	filter-lto

	local mycmakeargs=(
		$(cmake_use_find_package alsa ALSA)
		$(cmake_use_find_package jack JACK)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newicon resources/pictures/carton.png ${PN}.png
	make_desktop_entry --eapi9 ${PN} -n MilkyTracker -i ${PN} \
		-c "AudioVideo;Audio;Sequencer"
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

# This commit is needed so the milkytrace binary is linked properly, bug 711564
# It is also ~40kb so it is better to fetch it rather than ship it in-tree
COMMIT="2b145b074581ddf3b4ad78a402cdf5fab500b125"

DESCRIPTION="FastTracker 2 inspired music tracker"
HOMEPAGE="https://milkytracker.titandemo.org/"
SRC_URI="https://github.com/milkytracker/MilkyTracker/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/milkytracker/MilkyTracker/commit/${COMMIT}.patch -> ${P}-cmake.patch"

LICENSE="|| ( GPL-3 MPL-1.1 ) AIFFWriter.m BSD GPL-3 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack"

RDEPEND="
	dev-libs/zziplib
	media-libs/libsdl2[X]
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${DISTDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-CVE-2019-14464.patch"
	"${FILESDIR}/${P}-CVE-2019-1449x.patch"
	"${FILESDIR}/${P}-CVE-2020-15569.patch"
	"${FILESDIR}/${P}-fix-hard-dependency-on-rtmidi.patch"
)

S="${WORKDIR}/MilkyTracker-${PV}"

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

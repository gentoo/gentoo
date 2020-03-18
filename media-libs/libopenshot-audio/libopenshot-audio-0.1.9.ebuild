# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library for audio editing and playback used by OpenShot"
HOMEPAGE="https://www.openshot.org/"
SRC_URI="https://github.com/OpenShot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0/7"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
"
DEPEND="${RDEPEND}"

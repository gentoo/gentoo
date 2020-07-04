# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

COMMIT="77edb1f14dde35e1facecc309dbc4fb7f07d7014"

DESCRIPTION="Library for audio editing and playback used by OpenShot"
HOMEPAGE="https://www.openshot.org/"
SRC_URI="https://github.com/OpenShot/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0/6"
KEYWORDS="amd64 x86"

RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="a fork of multimon, decodes multiple digital transmission modes"
HOMEPAGE="https://github.com/EliasOenal/multimon-ng"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EliasOenal/multimon-ng.git"
else
	SRC_URI="https://github.com/EliasOenal/multimonNG/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="pulseaudio X"

DEPEND="pulseaudio? ( media-sound/pulseaudio )
		X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"
PDEPEND="media-sound/sox"

src_prepare() {
	use pulseaudio || sed -i '/find_package( PulseAudio )/d' CMakeLists.txt
	use X || sed -i '/find_package( X11 )/d' CMakeLists.txt
	cmake_src_prepare
}

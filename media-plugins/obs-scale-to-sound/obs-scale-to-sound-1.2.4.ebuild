# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="OBS filter plugin that scales a source reactively to sound levels"
HOMEPAGE="https://github.com/dimtpap/obs-scale-to-sound"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dimtpap/obs-scale-to-sound.git"
else
	SRC_URI="https://github.com/dimtpap/obs-scale-to-sound/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	>=media-video/obs-studio-30.2.0
"
RDEPEND="${DEPEND}"

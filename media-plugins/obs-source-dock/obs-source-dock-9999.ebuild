# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Plugin for OBS Studio to add docks"
HOMEPAGE="https://github.com/exeldro/obs-source-dock"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/exeldro/obs-source-dock.git"
else
	SRC_URI="https://github.com/exeldro/obs-source-dock/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	>=media-video/obs-studio-30.2.0[wayland]
	dev-qt/qtbase:6
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DLIB_OUT_DIR=/lib64/obs-plugins
		-DLINUX_PORTABLE=OFF
	)

	cmake_src_configure
}

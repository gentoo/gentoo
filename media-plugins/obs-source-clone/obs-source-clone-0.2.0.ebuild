# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Plugin for OBS Studio to clone sources"
HOMEPAGE="https://github.com/exeldro/obs-source-clone"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/exeldro/obs-source-clone.git"
else
	SRC_URI="https://github.com/exeldro/obs-source-clone/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	>=media-video/obs-studio-31.1.0
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i '/-Werror$/d' cmake/linux/compilerconfig.cmake || die
	cmake_src_prepare
}

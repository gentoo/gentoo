# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="OBS Simulcast support plugin"
HOMEPAGE="https://github.com/orayuki/obs-multi-rtmp"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sorayuki/obs-multi-rtmp.git"
else
	SRC_URI="https://github.com/sorayuki/obs-multi-rtmp/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+obs-frontend-api +qt"
RDEPEND="
	media-video/obs-studio
"

src_unpack() {
	default

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi
}

src_configure() {
	local mycmakeargs+=(
		-DENABLE_FRONTEND_API=$(usex obs-frontend-api ON OFF)
		-DENABLE_QT=$(usex qt ON OFF)
	)

	# code base is not clean
	# opened bug https://github.com/sorayuki/obs-multi-rtmp/issues/378
	append-cppflags -Wno-error=shadow -Wno-error=conversion -Wno-error=float-conversion -Wno-error=sign-compare

	cmake_src_configure
}

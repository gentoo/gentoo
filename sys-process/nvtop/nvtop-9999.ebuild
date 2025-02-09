# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="(h)top like task monitor for AMD, NVIDIA, Intel and other GPUs"
HOMEPAGE="https://github.com/Syllo/nvtop"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Syllo/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Syllo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

IUSE="unicode video_cards_intel video_cards_amdgpu video_cards_nvidia video_cards_freedreno video_cards_panfrost video_cards_panthor"

RDEPEND="
	video_cards_intel?  ( virtual/udev )
	video_cards_amdgpu? ( x11-libs/libdrm[video_cards_amdgpu] )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers )
	video_cards_freedreno? ( x11-libs/libdrm[video_cards_freedreno] )
	video_cards_panfrost? ( x11-libs/libdrm )
	video_cards_panthor? ( x11-libs/libdrm )
	sys-libs/ncurses[unicode(+)?]
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCURSES_NEED_WIDE=$(usex unicode)
		-DINTEL_SUPPORT=$(usex video_cards_intel)
		-DNVIDIA_SUPPORT=$(usex video_cards_nvidia)
		-DAMDGPU_SUPPORT=$(usex video_cards_amdgpu)
		-DMSM_SUPPORT=$(usex video_cards_freedreno)
		-DPANFROST_SUPPORT=$(usex video_cards_panfrost)
		-DPANTHOR_SUPPORT=$(usex video_cards_panthor)
	)

	cmake_src_configure
}

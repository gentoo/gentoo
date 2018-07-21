# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Accelerated Open Source driver for AMDGPU cards"
HOMEPAGE="https://www.x.org/wiki/ https://cgit.freedesktop.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/xorg/driver/xf86-video-amdgpu.git"
	inherit autotools git-r3
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="mirror://xorg/driver/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	>=x11-libs/libdrm-2.4.78[video_cards_amdgpu]
	x11-libs/libpciaccess
	x11-base/xorg-server:=[glamor(-),-minimal]
"
DEPEND="
	${LIVE_DEPEND}
	${RDEPEND}
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	local econfargs=(
		--disable-selective-werror
		--enable-glamor
	)

	econf "${econfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

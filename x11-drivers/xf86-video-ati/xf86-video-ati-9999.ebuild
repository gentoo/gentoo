# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="ATI video driver"
HOMEPAGE="https://www.x.org/wiki/ati/"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/xorg/driver/${PN}"
	inherit autotools git-r3
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="mirror://xorg/driver/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+glamor udev"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	>=x11-libs/libdrm-2.4.78[video_cards_radeon]
	>=x11-libs/libpciaccess-0.8.0
	glamor? ( x11-base/xorg-server[glamor] )
	udev? ( virtual/libudev:= )
"
DEPEND="
	${LIVE_DEPEND}
	${RDEPEND}
	x11-base/xorg-proto
"

pkg_pretend() {
	if use kernel_linux ; then
		if kernel_is -ge 3 9; then
			CONFIG_CHECK="~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_RADEON_KMS ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	local econfargs=(
		$(use_enable glamor)
		$(use_enable udev)
	)
	econf "${econfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

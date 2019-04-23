# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="X Compositing manager"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/app/xcompmgr"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/app/xcompmgr.git"
	inherit autotools git-r3
	# x11-misc-util/macros only required on live ebuilds
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="mirror://xorg/app/${P}.tar.bz2"
	KEYWORDS="amd64 ppc ppc64 sparc x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXcomposite
	x11-libs/libXext
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
	)

	econf "${econfargs[@]}"
}

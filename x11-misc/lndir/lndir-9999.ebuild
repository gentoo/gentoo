# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="create a shadow directory of symbolic links to another directory tree"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/util/lndir"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/util/lndir.git"
	inherit autotools git-r3
	# x11-misc-util/macros only required on live ebuilds
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="https://www.x.org/releases/individual/util/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND=""
DEPEND="
	${LIVE_DEPEND}
	${RDEPEND}
	x11-base/xorg-proto
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

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="X.org input driver based on libinput"
HOMEPAGE="https://www.x.org/wiki/ https://cgit.freedesktop.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/xorg/driver/xf86-input-libinput.git"
	inherit autotools git-r3
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="mirror://xorg/driver/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	>=x11-base/xorg-server-1.10:=
	>=dev-libs/libinput-1.5.0:0=
"
DEPEND="
	${LIVE_DEPEND}
	${RDEPEND}
	x11-base/xorg-proto
"

pkg_pretend() {
	CONFIG_CHECK="~TIMERFD"
	check_extra_config
}

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

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

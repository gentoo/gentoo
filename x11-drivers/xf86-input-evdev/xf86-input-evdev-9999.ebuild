# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="Generic Linux input driver"
HOMEPAGE="https://www.x.org/wiki/ https://cgit.freedesktop.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/xorg/driver/xf86-input-evdev.git"
	inherit autotools git-r3
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="mirror://xorg/driver/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh sparc x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/libevdev
	sys-libs/mtdev
	virtual/libudev:=
	>=x11-base/xorg-server-1.18[udev]
"
DEPEND="
	${LIVE_DEPEND}
	${RDEPEND}
	>=sys-kernel/linux-headers-2.6
	x11-base/xorg-proto
	x11-misc/util-macros
"

pkg_pretend() {
	if use kernel_linux ; then
		CONFIG_CHECK="~INPUT_EVDEV"
	fi
	check_extra_config
}

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

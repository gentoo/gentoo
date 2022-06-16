# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
XORG_TARBALL_SUFFIX="xz"

inherit linux-info xorg-3

DESCRIPTION="X.org input driver based on libinput"

KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 sparc ~x86"

RDEPEND=">=dev-libs/libinput-1.11.0:0="
DEPEND="${RDEPEND}
	>=x11-base/xorg-proto-2021.5"

DOCS=( "README.md" )

pkg_pretend() {
	CONFIG_CHECK="~TIMERFD"
	check_extra_config
}

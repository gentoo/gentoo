# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info xorg-3

DESCRIPTION="X.org input driver based on libinput"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

RDEPEND=">=dev-libs/libinput-1.7.0:0="
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( "README.md" )

pkg_pretend() {
	CONFIG_CHECK="~TIMERFD"
	check_extra_config
}

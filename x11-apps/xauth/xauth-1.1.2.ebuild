# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
XORG_TARBALL_SUFFIX=xz
inherit xorg-3

if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux"
fi

DESCRIPTION="X authority file utility"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXext
	x11-libs/libXmu"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		--enable-ipv6
	)
	xorg-3_src_configure
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
XORG_TARBALL_SUFFIX="xz"

inherit xorg-3

DESCRIPTION="primitive command line interface to RandR extension"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/libXrandr-1.5
	x11-libs/libXrender
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_install() {
	xorg-3_src_install
	rm -f "${ED}"/usr/bin/xkeystone || die
}

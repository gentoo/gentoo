# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="primitive command line interface to RandR extension"

SRC_URI="${XORG_BASE_INDIVIDUAL_URI}/${XORG_MODULE}${P}.tar.xz"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
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

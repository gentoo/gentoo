# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MODULE=test/
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3 meson

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

DESCRIPTION="Tests for compliance with X RENDER extension"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/test/rendercheck"
LICENSE="MIT GPL-2+"

RDEPEND="
	x11-libs/libXrender
	x11-libs/libXext
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

# Override xorg-3's src_prepare
src_prepare() {
	default
}

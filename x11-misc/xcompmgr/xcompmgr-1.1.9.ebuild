# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MODULE=app/
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="X Compositing manager"

LICENSE="BSD"
KEYWORDS="amd64 ~arm64 ppc ppc64 sparc x86"

RDEPEND="
	x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXcomposite
	x11-libs/libXext
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

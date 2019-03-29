# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_MODULE=app/
XORG_STATIC=no
inherit xorg-2

DESCRIPTION="Tests for compliance with X RENDER extension"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/test/rendercheck"

KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libXrender
	x11-libs/libX11"
DEPEND="${RDEPEND}"

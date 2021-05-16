# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="threads(+)"

inherit python-any-r1 waf-utils

DESCRIPTION="X terminal emulator rendering through OpenGL ES Compute Shaders"
HOMEPAGE="https://tomscii.sig7.se/zutty/ https://github.com/tomszilagyi/zutty"
SRC_URI="https://github.com/tomszilagyi/zutty/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="
	media-libs/freetype:2
	media-libs/libglvnd[X]
	x11-libs/libXmu"
DEPEND="
	${COMMON_DEPEND}
	${PYTHON_DEPS}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( doc/KEYS.org doc/USAGE.org )

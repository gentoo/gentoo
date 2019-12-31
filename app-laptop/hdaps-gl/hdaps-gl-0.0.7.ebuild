# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenGL visualization for HDAPS data"
HOMEPAGE="https://github.com/linux-thinkpad/${PN}"
SRC_URI="${HOMEPAGE}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND=""
DEPEND="media-libs/freeglut
	media-libs/glu
	virtual/opengl"
RDEPEND="${DEPEND}"

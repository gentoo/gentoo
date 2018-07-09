# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="animate an icosahedron or other polyhedron"
HOMEPAGE="https://www.x.org/wiki/ https://cgit.freedesktop.org/"
SRC_URI="mirror://xorg/app/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-linux"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-misc/util-macros
"

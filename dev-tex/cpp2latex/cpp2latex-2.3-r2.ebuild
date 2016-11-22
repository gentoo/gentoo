# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A program to convert C++ code to LaTeX source"
HOMEPAGE="http://www.arnoldarts.de/cpp2latex/"
SRC_URI="http://www.arnoldarts.de/files/cpp2latex/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

# first patch: bug #44585, second patch bug #227863
PATCHES=(
	"${FILESDIR}/${P}.patch"
	"${FILESDIR}/${P}-gcc43.patch"
	"${FILESDIR}/${P}-tests.patch"
)

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Utility to optimize JPEG files"
HOMEPAGE="http://www.kokkonen.net/tjko/projects.html https://github.com/tjko/jpegoptim"
SRC_URI="http://www.kokkonen.net/tjko/src/${P}.tar.gz"

LICENSE="GPL-2+" # While COPYING is plain GPL-2, COPYRIGHT is clarifying it to be 'any later version'
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="virtual/jpeg:0"
DEPEND="${RDEPEND}"

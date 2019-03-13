# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Utility to optimize JPEG files"
HOMEPAGE="https://www.kokkonen.net/tjko/projects.html"
SRC_URI="https://www.kokkonen.net/tjko/src/${P}.tar.gz"

LICENSE="GPL-2+" # While COPYING is plain GPL-2, COPYRIGHT is clarifying it to be 'any later version'
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="virtual/jpeg:0"
DEPEND="${RDEPEND}"

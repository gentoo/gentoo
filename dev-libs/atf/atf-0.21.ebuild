# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ltprune

DESCRIPTION="Libraries to write tests in C, C++ and shell"
HOMEPAGE="https://github.com/jmmv/atf"
SRC_URI="https://github.com/jmmv/atf/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/pkgconfig"

src_install() {
	default
	prune_libtool_files
}

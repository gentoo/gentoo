# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A portable file archiver using QuickLZ algorithm"
HOMEPAGE="https://github.com/PierreLvx/qpress"
SRC_URI="https://github.com/PierreLvx/qpress/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-1 GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	# Remove custom CXXFLAGS
	sed -i -e ":-Werror:d" makefile || die
}

src_install() {
	dobin qpress
	dodoc readme.md
}

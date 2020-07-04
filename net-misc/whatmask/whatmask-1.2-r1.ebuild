# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="little C program to compute different subnet mask notations"
HOMEPAGE="http://www.laffeycomputer.com/whatmask.html"
SRC_URI="http://downloads.laffeycomputer.com/current_builds/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc sparc x86"

DOCS=( AUTHORS ChangeLog INSTALL NEWS README )

src_configure() {
	tc-export CC
	default
}

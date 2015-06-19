# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/whatmask/whatmask-1.2-r1.ebuild,v 1.7 2012/01/19 16:36:10 jer Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="little C program to compute different subnet mask notations"
HOMEPAGE="http://www.laffeycomputer.com/whatmask.html"
SRC_URI="http://downloads.laffeycomputer.com/current_builds/whatmask/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc sparc x86"
IUSE=""

DOCS=( AUTHORS ChangeLog INSTALL NEWS README )

src_prepare() {
	tc-export CC
}

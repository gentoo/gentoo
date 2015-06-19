# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/scope/scope-0.04-r1.ebuild,v 1.4 2013/03/03 00:06:41 pinkbyte Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Serial Line Analyser"
HOMEPAGE="http://www.gumbley.me.uk/scope.html"
SRC_URI="http://www.gumbley.me.uk/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS=( README )

src_prepare() {
	# bug 459848
	tc-export CC
}

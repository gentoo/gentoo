# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Serial Line Analyser"
HOMEPAGE="http://www.gumbley.me.uk/scope.html"
SRC_URI="http://www.gumbley.me.uk/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS=( "README" )

src_prepare() {
	# bug 459848
	tc-export CC
	eapply_user
}

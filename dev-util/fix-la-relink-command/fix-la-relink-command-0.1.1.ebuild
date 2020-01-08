# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Helps prevent .la files from relinking to libraries outside a build tree"
HOMEPAGE="https://dev.gentoo.org/~tetromino/distfiles/${PN}"
SRC_URI="https://dev.gentoo.org/~tetromino/distfiles/${PN}/${P}.tar.xz"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-lang/perl
	virtual/perl-Getopt-Long"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc NEWS
}

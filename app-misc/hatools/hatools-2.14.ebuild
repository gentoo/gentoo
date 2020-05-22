# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="High availability environment tools for shell scripting"
HOMEPAGE="http://www.fatalmind.com/software/hatools/"
SRC_URI="http://www.fatalmind.com/software/hatools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~mips ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	default
	sed 's:ksh:bash:g' -i test.sh || die
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="High availability environment tools for shell scripting"
HOMEPAGE="https://www.fatalmind.com/software/hatools/"
SRC_URI="http://www.fatalmind.com/software/hatools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	default
	sed 's:ksh:bash:g' -i test.sh || die
}

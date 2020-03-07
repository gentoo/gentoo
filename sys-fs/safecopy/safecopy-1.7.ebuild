# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tool for fault-tolerant data recovery from damaged (io-errors) devices or files"
HOMEPAGE="http://safecopy.sourceforge.net"
SRC_URI="mirror://sourceforge/safecopy/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS=( README )

src_configure() {
	econf
	cd simulator || die
	use test && econf
}

src_compile() {
	emake
	use test && emake -C simulator
}

src_test() {
	cd test || die
	./test.sh || die
}

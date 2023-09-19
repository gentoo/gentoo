# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool for fault-tolerant data recovery from damaged (IO-errors) devices or files"
HOMEPAGE="https://safecopy.sourceforge.net"
SRC_URI="mirror://sourceforge/safecopy/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${PN}-tests.patch )
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

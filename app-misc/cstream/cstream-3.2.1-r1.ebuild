# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="General-purpose stream-handling tool like UNIX dd"
HOMEPAGE="http://www.cons.org/cracauer/cstream.html"
SRC_URI="http://www.cons.org/cracauer/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.1-Fix-implicit-function-declaration.patch
)

src_prepare() {
	default

	rm auxdir/missing || die "Failed to remove auxdir/missing"

	eautoreconf
}

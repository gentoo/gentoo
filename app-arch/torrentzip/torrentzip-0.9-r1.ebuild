# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Create identical zip archives over multiple systems"
HOMEPAGE="https://sourceforge.net/projects/trrntzip"
SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS=(README AUTHORS)

PATCHES=("${FILESDIR}/${P}-autoconf-quote.patch")

src_prepare() {
	default
	export CPPFLAGS+=" -DOF\\(args\\)=args"
	eautoreconf
}

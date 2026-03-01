# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker toolchain-funcs autotools

DESCRIPTION="A lightweight Relax NG Compact Syntax validator"
HOMEPAGE="http://www.davidashen.net/rnv.html"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/expat
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e "/^AR/s/ar/$(tc-getAR)/" Makefile.in || die 'sed on Makefile.in failed'
	eautoreconf
}

src_configure() {
	LIBS="-ldl -lm" \
		econf \
		--disable-scm
}

src_install() {
	default
	dodoc readme.txt
}

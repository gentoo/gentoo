# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker toolchain-funcs

DESCRIPTION="A lightweight Relax NG Compact Syntax validator"
HOMEPAGE="http://www.davidashen.net/rnv.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/expat
	dev-scheme/scm[libscm]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e "/^AR/s/ar/$(tc-getAR)/" Makefile.in || die 'sed on Makefile.in failed'
}

src_configure() {
	LIBS="-ldl -lm" \
		econf \
		--with-scm-inc="/usr/include" \
		--with-scm-lib="/usr/$(get_libdir)"
}

src_install() {
	default
	dodoc readme.txt
}

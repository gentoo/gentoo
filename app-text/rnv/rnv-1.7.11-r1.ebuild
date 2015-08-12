# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit unpacker toolchain-funcs

DESCRIPTION="A lightweight Relax NG Compact Syntax validator"
HOMEPAGE="http://www.davidashen.net/rnv.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scheme"

RDEPEND="dev-libs/expat
	scheme? ( dev-scheme/scm[libscm] )"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "/^AR/s/ar/$(tc-getAR)/" Makefile.in || die 'sed on Makefile.in failed'
}

src_configure() {
	LIBS="-ldl -lm" \
		econf $(use_with scheme scm /usr)
}

src_install() {
	default
	dodoc readme.txt
}

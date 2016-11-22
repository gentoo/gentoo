# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="a tool to do fuzzy fingerprinting for man-in-the-middle attacks"
HOMEPAGE="http://www.thc.org/thc-ffp/"
SRC_URI="http://www.thc.org/releases/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libressl"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
"
RDEPEND="${DEPEND}"

DOCS=( README TODO doc/ffp.pdf )

src_prepare() {
	tc-export CC
}
src_install() {
	default
	dohtml doc/ffp.html
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ffp/ffp-0.0.8-r1.ebuild,v 1.2 2014/07/11 12:12:34 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="a tool to do fuzzy fingerprinting for man-in-the-middle attacks"
HOMEPAGE="http://www.thc.org/thc-ffp/"
SRC_URI="http://www.thc.org/releases/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

DOCS=( README TODO doc/ffp.pdf )

src_prepare() {
	tc-export CC
}
src_install() {
	default
	dohtml doc/ffp.html
}

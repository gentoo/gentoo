# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/grok/grok-0.9.2.ebuild,v 1.2 2014/06/04 16:47:40 ercpe Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="DRY and RAD for regular expressions"
HOMEPAGE="https://github.com/jordansissel/grok http://code.google.com/p/semicomplete/wiki/Grok"
SRC_URI="https://github.com/jordansissel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-db/tokyocabinet
		>=dev-libs/libevent-1.3
		>=dev-libs/libpcre-7.6"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-*.patch
	tc-export CC
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Multiple Repository management tool"
HOMEPAGE="https://myrepos.branchable.com/"
SRC_URI="https://dev.gentoo.org/~tamiko/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/libwww-perl
	dev-perl/HTML-Parser"

src_install() {
	dobin mr webcheckout
	doman mr.1 webcheckout.1
	dodoc README debian/changelog \
		mrconfig mrconfig.complex
	insinto /usr/share/${PN}
	doins lib/*
}

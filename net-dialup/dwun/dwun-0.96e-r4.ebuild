# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Dialer Without a Useful Name (DWUN)"
HOMEPAGE="http://dwun.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="~amd64 x86"

DOCS=( AUTHORS ChangeLog QUICKSTART README TODO UPGRADING )

src_prepare() {
	sed -i -e "s:TODO QUICKSTART README UPGRADING ChangeLog COPYING AUTHORS::" Makefile.in || die
	tc-export CC

	eapply_user
}

src_configure() {
	econf --with-docdir="share/doc/${PF}"
}

src_install() {
	default

	insinto /etc
	newins doc/examples/complete-rcfile dwunrc
	newins debian/dwunauth dwunauth
	newinitd "${FILESDIR}/dwun" dwun
}

pkg_postinst() {
	elog
	elog 'Make sure you have "net-dialup/ppp" merged if you intend to use dwun'
	elog "to control a standard PPP network link."
	elog "See /usr/share/doc/${P}/QUICKSTART for instructions on"
	elog "configuring dwun."
	elog
}

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/hashcash/hashcash-1.22-r1.ebuild,v 1.3 2010/10/28 10:07:31 ssuominen Exp $

inherit eutils toolchain-funcs

IUSE=""
DESCRIPTION="Utility to generate hashcash tokens"
HOMEPAGE="http://www.hashcash.org"
SRC_URI="http://www.hashcash.org/source/${P}.tgz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "/COPT_GENERIC = -O3/d" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" generic || die
}

src_install() {
	dobin hashcash
	doman hashcash.1
	dodoc CHANGELOG
	insinto /usr/share/doc/${PF}/examples
	doins contrib/hashcash-{request,sendmail{,.txt}} \
		contrib/hashfork.{c,py,txt}
}

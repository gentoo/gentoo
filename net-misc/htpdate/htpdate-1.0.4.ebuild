# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/htpdate/htpdate-1.0.4.ebuild,v 1.9 2014/01/18 10:37:30 vapier Exp $

inherit toolchain-funcs

DESCRIPTION="Synchronize local workstation with time offered by remote webservers"
HOMEPAGE="http://www.clevervest.com/htp/"
SRC_URI="http://www.clevervest.com/htp/archive/c/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~mips ppc ~ppc64 s390 sh x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	gunzip htpdate.8.gz || die
}

src_compile() {
	emake CFLAGS="-Wall ${CFLAGS} ${LDFLAGS}" CC="$(tc-getCC)" || die
}

src_install() {
	dosbin htpdate || die
	doman htpdate.8
	dodoc README Changelog

	newconfd "${FILESDIR}"/htpdate.conf htpdate
	newinitd "${FILESDIR}"/htpdate.init htpdate
}

pkg_postinst() {
	einfo "If you would like to run htpdate as a daemon set"
	einfo "appropriate http servers in /etc/conf.d/htpdate!"
}

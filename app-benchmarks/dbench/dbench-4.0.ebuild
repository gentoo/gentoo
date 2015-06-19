# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/dbench/dbench-4.0.ebuild,v 1.10 2014/06/19 14:14:16 creffett Exp $
EAPI=5

inherit eutils autotools

DESCRIPTION="Popular filesystem benchmark"
SRC_URI="ftp://ftp.samba.org/pub/tridge/dbench/${P}.tar.gz"
HOMEPAGE="http://samba.org/ftp/tridge/dbench/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-libs/popt"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoheader
	eautoconf
	sed -i -e \
		"s:\$(CC) -o:\$(CC) \$(LDFLAGS) -o:" \
		Makefile.in || die
	eautoreconf
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin dbench tbench tbench_srv
	dodoc README INSTALL
	doman dbench.1
	insinto /usr/share/dbench
	doins client.txt
}

pkg_postinst() {
	elog "You can find the client.txt file in ${ROOT}usr/share/dbench."
}

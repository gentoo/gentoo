# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sieve Command Line Interface"
HOMEPAGE="https://people.spodhuis.org/phil.pennock/software/"
SRC_URI="https://github.com/syscomet/sieve-connect/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

DEPEND=">=dev-lang/perl-5"
RDEPEND="${DEPEND}
	>=dev-perl/Authen-SASL-2.11
	dev-perl/IO-Socket-INET6
	>=dev-perl/IO-Socket-SSL-0.97
	dev-perl/Net-DNS
	dev-perl/Net-SSLeay
	dev-perl/TermReadKey
	dev-perl/Term-ReadLine-Gnu"

src_compile() {
	emake all sieve-connect.1
}

src_install() {
	dobin sieve-connect
	doman sieve-connect.1
	dodoc README*
}

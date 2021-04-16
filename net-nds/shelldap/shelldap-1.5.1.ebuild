# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GENTOO_DEPEND_ON_PERL=noslotop
inherit perl-module

DESCRIPTION="A handy shell-like interface for browsing LDAP servers and editing their content"
HOMEPAGE="https://github.com/mahlonsmith/shelldap"
SRC_URI="https://github.com/mahlonsmith/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+readline sasl +ssl"

RDEPEND="dev-perl/Algorithm-Diff
	sasl? ( dev-perl/Authen-SASL )
	dev-perl/IO-Socket-SSL
	dev-perl/perl-ldap
	dev-perl/TermReadKey
	readline? ( dev-perl/Term-ReadLine-Gnu )
	dev-perl/Term-Shell
	dev-perl/Tie-IxHash
	dev-perl/YAML-Syck
	virtual/perl-Data-Dumper
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	virtual/perl-Digest-MD5"

src_configure() { :; }

src_compile() {
	pod2man --name "${PN}" < "${PN}" > "${PN}.1" || die 'creating manpage failed'
}

src_install() {
	doman "${PN}.1"
	dobin "${PN}"
	dodoc USAGE
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARSCHAP
DIST_VERSION=0.68
inherit perl-module

DESCRIPTION="Perl modules which provide an object-oriented interface to LDAP servers"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="sasl xml ssl"

RDEPEND="
	dev-perl/Authen-SASL
	dev-perl/Convert-ASN1
	dev-perl/IO-Socket-INET6
	dev-perl/URI
	sasl? (
		virtual/perl-Digest-MD5
		dev-perl/Authen-SASL
	)
	xml? (
		dev-perl/XML-Parser
		dev-perl/XML-SAX
		dev-perl/XML-SAX-Writer
	)
	ssl? (
		>=dev-perl/IO-Socket-SSL-1.26
	)"
BDEPEND="${RDEPEND}
"

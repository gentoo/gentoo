# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARSCHAP
DIST_VERSION=0.65
inherit perl-module

DESCRIPTION="Perl modules which provide an object-oriented interface to LDAP servers"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="sasl xml ssl"

RDEPEND="
	dev-perl/Convert-ASN1
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
DEPEND="${RDEPEND}"

DIST_TEST=skip
# why?

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

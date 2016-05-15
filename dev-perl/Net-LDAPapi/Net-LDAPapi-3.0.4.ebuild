# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MISHIKAL

inherit eutils multilib perl-module

DESCRIPTION="Perl5 Module Supporting LDAP API"
HOMEPAGE="http://sourceforge.net/projects/net-ldapapi/
	http://search.cpan.org/~mishikal/Net-LDAPapi/"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
# LICENSE is given on the corresponding sourceforge project and matches the
# default cpan/perl license

RDEPEND="net-nds/openldap[sasl]
	dev-libs/cyrus-sasl
	dev-perl/Convert-ASN1"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

# NOTE: tests are available but they hang
# Tests also require hand-customised live LDAP server
# and configured LDAP Search Base
RESTRICT="test"

PATCHES=("${FILESDIR}/${PV}-ldap_result-no_error.patch")

src_configure() {
	myconf="-sdk OpenLDAP -lib_path /usr/$(get_libdir) -include_path /usr/include"
	perl-module_src_configure
}

src_install() {
	mydoc="Credits Todo"
	perl-module_src_install
	if use examples ; then
		docompress -x usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

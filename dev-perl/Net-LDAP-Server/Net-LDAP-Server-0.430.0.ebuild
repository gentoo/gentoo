# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-LDAP-Server/Net-LDAP-Server-0.430.0.ebuild,v 1.1 2015/05/04 03:09:42 zerochaos Exp $
EAPI=5
MODULE_AUTHOR=AAR
MODULE_VERSION=0.43
inherit perl-module

DESCRIPTION="LDAP server side protocol handling"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PERL_RM_FILES=(
	t/02-pod.t
	t/03-podcoverage.t
)

# Net::LDAP -> perl-ldap
RDEPEND="dev-perl/perl-ldap
	dev-perl/Convert-ASN1"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"

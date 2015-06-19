# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-1.040.0-r1.ebuild,v 1.3 2015/05/11 20:56:13 pacho Exp $

EAPI=5

MODULE_AUTHOR=PHRED
MODULE_VERSION=1.04
inherit perl-module eutils

DESCRIPTION="Simple and lightweight interface to the SOAP protocol (sic) both on client and server side"

IUSE="ssl xmpp"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

myconf="${myconf} --noprompt"

# TESTS ARE DISABLED ON PURPOSE
# This module attempts to access an external website for validation
# of the MIME::Parser - not only is that bad practice in general,
# but in this particular case the external site isn't even valid anymore# -mpc
# 24/10/04
SRC_TEST="do"

DEPEND="
	dev-perl/Class-Inspector
	dev-perl/XML-Parser
	dev-perl/libwww-perl
	virtual/perl-libnet
	dev-perl/MIME-Lite
	virtual/perl-MIME-Base64
	ssl? ( dev-perl/Crypt-SSLeay )
	xmpp? ( dev-perl/Net-Jabber )
	ssl? ( dev-perl/IO-Socket-SSL )
	virtual/perl-IO-Compress
	>=dev-perl/MIME-tools-5.413
	virtual/perl-version
"
RDEPEND="${DEPEND}"

src_test() {
	has_version '>=www-apache/mod_perl-2' && export MOD_PERL_API_VERSION=2
	perl-module_src_test
}

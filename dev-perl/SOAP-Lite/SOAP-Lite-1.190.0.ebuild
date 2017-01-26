# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PHRED
MODULE_VERSION=1.19
inherit perl-module eutils

DESCRIPTION="Lightweight interface to the SOAP protocol both on client and server side"

IUSE="ssl test xmpp"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

myconf="${myconf} --noprompt"

RDEPEND="
	dev-perl/Class-Inspector
	>=dev-perl/IO-SessionData-1.30.0
	dev-perl/libwww-perl
	virtual/perl-MIME-Base64
	virtual/perl-Scalar-List-Utils
	dev-perl/Task-Weaken
	dev-perl/URI
	>=dev-perl/XML-Parser-2.230.0
	dev-perl/MIME-tools
	ssl? (
		dev-perl/IO-Socket-SSL
		dev-perl/LWP-Protocol-https
		dev-perl/Crypt-SSLeay
	)
	xmpp? ( dev-perl/Net-Jabber )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-IO
		virtual/perl-Test-Simple
		dev-perl/Test-Warn
		dev-perl/XML-Parser-Lite
	)
"

SRC_TEST="do parallel"

src_test() {
	has_version '>=www-apache/mod_perl-2' && export MOD_PERL_API_VERSION=2
	perl-module_src_test
}

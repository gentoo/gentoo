# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Sender/Email-Sender-1.300.11.ebuild,v 1.1 2014/07/11 22:02:00 zlogene Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.300011
inherit perl-module

DESCRIPTION="A library for sending email"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Scalar-List-Utils
	virtual/perl-File-Spec
	>=dev-perl/Email-Abstract-3
	dev-perl/Email-Address
	dev-perl/Email-Simple
	dev-perl/List-MoreUtils
	dev-perl/Net-SMTP-SSL
	>=dev-perl/Throwable-0.200.3
	dev-perl/Try-Tiny
	virtual/perl-libnet
	>=dev-perl/Moo-1.0.8
	dev-perl/Module-Runtime
	>=dev-perl/MooX-Types-MooseLike-0.150.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.31
	test? (
		>=dev-perl/Capture-Tiny-0.08
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST=do

src_test() {
	# https://rt.cpan.org/Public/Bug/Display.html?id=54642
	mv "${S}"/t/smtp-via-mock.t{,.disable} || die
	perl-module_src_test
}

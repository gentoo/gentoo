# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Sender/Email-Sender-1.300.16.ebuild,v 1.1 2014/10/25 19:25:56 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.300016
inherit perl-module

DESCRIPTION="A library for sending email"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Email-Abstract-3.6.0
	dev-perl/Email-Address
	>=dev-perl/Email-Simple-1.998.0
	>=virtual/perl-File-Path-2.60.0
	virtual/perl-File-Spec
	virtual/perl-IO
	dev-perl/List-MoreUtils
	dev-perl/Module-Runtime
	>=dev-perl/Moo-1.0.8
	>=dev-perl/MooX-Types-MooseLike-0.150.0
	virtual/perl-libnet
	dev-perl/Net-SMTP-SSL
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Exporter
	>=dev-perl/Throwable-0.200.3
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Capture-Tiny-0.08
		virtual/perl-Exporter
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST=do

src_test() {
	# https://rt.cpan.org/Public/Bug/Display.html?id=54642
	mv "${S}"/t/smtp-via-mock.t{,.disable} || die
	perl-module_src_test
}

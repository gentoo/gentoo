# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.196
inherit perl-module

DESCRIPTION="Check validity of Internet email addresses"

SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc ppc64 x86 ~x86-linux"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	dev-perl/IO-CaptureOutput
	virtual/perl-IO
	dev-perl/MailTools
	dev-perl/Net-DNS
	>=dev-perl/Net-Domain-TLD-1.650.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="
	test? ( ${RDEPEND}
		dev-perl/Capture-Tiny
		>=virtual/perl-Test-Simple-0.960.0
	)"

SRC_TEST="do"

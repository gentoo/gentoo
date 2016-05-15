# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.11

inherit perl-module

DESCRIPTION="Domain and host name validation"

SLOT="0"
KEYWORDS="amd64 ~hppa"
IUSE="test"

RDEPEND="
	virtual/perl-Exporter
	dev-perl/Net-Domain-TLD
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST="do parallel"

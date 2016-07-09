# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="DROLSKY"
MODULE_VERSION="0.24"

inherit perl-module

DESCRIPTION="Lightweight IPv4 and IPv6 validation module"

SLOT="0"
KEYWORDS="amd64 ~hppa ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Exporter
	>=dev-perl/NetAddr-IP-4
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Requires
	)
"

SRC_TEST=do

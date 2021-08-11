# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RRWO
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="A module to retrieve system load averages"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Exporter
	virtual/perl-IO
	virtual/perl-XSLoader
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
		dev-perl/Test-Warnings
	)
"

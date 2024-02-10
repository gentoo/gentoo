# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="Export shared globs with Sub::Exporter collectors"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/Sub-Exporter
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"

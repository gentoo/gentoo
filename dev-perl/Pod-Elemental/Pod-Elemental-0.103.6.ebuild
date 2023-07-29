# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.103006
inherit perl-module

DESCRIPTION="Work with nestable Pod elements"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/Class-Load
	virtual/perl-Encode
	virtual/perl-Scalar-List-Utils
	dev-perl/Mixin-Linewise
	dev-perl/Moose
	dev-perl/MooseX-Types
	>=dev-perl/Pod-Eventual-0.4.0
	dev-perl/String-RewritePrefix
	dev-perl/String-Truncate
	dev-perl/Sub-Exporter
	dev-perl/Sub-Exporter-ForMethods
	dev-perl/namespace-autoclean
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		dev-perl/Test-Deep
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.960.0
	)
"

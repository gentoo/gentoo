# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.101246
inherit perl-module

DESCRIPTION="String munging for loggers"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/JSON-MaybeXS
	dev-perl/Params-Util
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Exporter
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.009
inherit perl-module

DESCRIPTION="Simple sprintf-like dialect"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Params-Util
	virtual/perl-Scalar-List-Utils
	>=dev-perl/String-Formatter-0.102.81
	dev-perl/Sub-Exporter
	virtual/perl-Time-Piece
	virtual/perl-parent
"

BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		dev-perl/TimeDate
		virtual/perl-File-Spec
		dev-perl/JSON-MaybeXS
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-autodie
	)
"

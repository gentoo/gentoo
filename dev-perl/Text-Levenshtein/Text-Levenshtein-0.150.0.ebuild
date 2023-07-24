# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="An implementation of the Levenshtein edit distance"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Unicode-Collate-1.40.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-parent
	)
"

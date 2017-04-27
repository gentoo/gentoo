# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6
DIST_AUTHOR=LEONT
DIST_VERSION=0.026
inherit perl-module

DESCRIPTION="Various portability utilities for module builders"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-File-Spec
	>=virtual/perl-Text-ParseWords-3.240.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.014
inherit perl-module

DESCRIPTION="Change directory temporarily for a limited scope"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-File-Temp
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-version
	)
"

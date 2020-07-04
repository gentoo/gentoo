# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.000
inherit perl-module

DESCRIPTION="Increment module version numbers simply and correctly"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
LICENSE="Apache-2.0"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Sub-Exporter
	>=virtual/perl-version-0.810.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		virtual/perl-File-Spec
		>=dev-perl/Test-Exception-0.290.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"

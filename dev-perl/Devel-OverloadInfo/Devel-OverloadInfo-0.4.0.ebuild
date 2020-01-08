# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILMARI
DIST_VERSION=0.004
inherit perl-module

DESCRIPTION="Introspect overloaded operators"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 hppa ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# Scalar::Util -> Scalar-List-Utils
RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	dev-perl/MRO-Compat
	>=dev-perl/Package-Stash-0.140.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Identify
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-parent
	)
"

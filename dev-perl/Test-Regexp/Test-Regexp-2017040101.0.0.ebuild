# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

DIST_AUTHOR=ABIGAIL
DIST_VERSION=$(get_major_version)

inherit perl-module

DESCRIPTION="Provide commonly requested regular expressions"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( >=virtual/perl-Test-Simple-1.1.14 )
	virtual/perl-ExtUtils-MakeMaker
"
RDEPEND="
	virtual/perl-Test-Simple
	virtual/perl-Exporter
"

src_test() {
	# Omit code coverage / documentation tests
	perl_rm_files t/{950,960,980,981,982}*.t

	perl-module_src_test
}

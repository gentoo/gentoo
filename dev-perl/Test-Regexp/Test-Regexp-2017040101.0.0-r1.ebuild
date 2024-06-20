# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ABIGAIL
DIST_VERSION=2017040101
inherit perl-module

DESCRIPTION="Provide commonly requested regular expressions"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	virtual/perl-Test-Simple
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-1.1.14 )
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	# Omit code coverage / documentation tests
	perl_rm_files t/{950,960,980,981,982}*.t

	perl-module_src_test
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.016
inherit perl-module

DESCRIPTION='Test for warnings and the lack of them'

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ppc ppc64 ~s390 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# Test::Builder -> perl-Test-Simple
RDEPEND="
	virtual/perl-Exporter
	virtual/perl-Test-Simple
	virtual/perl-parent
"
# File::Spec::Functions -> perl-File-Spec
# List::Util -> perl-Scalar-List-Utils
# Test::More -> perl-Test-Simple
DEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	${RDEPEND}
	test? (
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		virtual/perl-Test-Simple
		virtual/perl-if
		virtual/perl-version
	)
"

SRC_TEST="do parallel"

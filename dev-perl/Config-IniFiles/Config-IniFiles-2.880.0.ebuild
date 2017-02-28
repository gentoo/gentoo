# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SHLOMIF
MODULE_VERSION=2.88
inherit perl-module

DESCRIPTION="A module for reading .ini-style configuration files"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

# needs List::Util and Scalar::Util
RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Temp
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	virtual/perl-File-Spec
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t       \
			t/cpan-changes.t t/style-trailing-space.t
	perl-module_src_test
}

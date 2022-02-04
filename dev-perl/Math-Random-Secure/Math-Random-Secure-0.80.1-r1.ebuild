# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FREW
DIST_VERSION=0.080001
inherit perl-module

DESCRIPTION="Cryptographically-secure, cross-platform replacement for rand()"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-perl/Moo-2.0.0
	>=dev-perl/Crypt-Random-Source-0.70
	>=dev-perl/Math-Random-ISAAC-1.1.0
	dev-perl/Math-Random-ISAAC-XS
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/List-MoreUtils
		virtual/perl-Test-Simple
		dev-perl/Test-SharedFork
		dev-perl/Test-Warn
	)
"

src_test() {
	perl_rm_files t/author-*.t t/release-*.t
	perl-module_src_test
}

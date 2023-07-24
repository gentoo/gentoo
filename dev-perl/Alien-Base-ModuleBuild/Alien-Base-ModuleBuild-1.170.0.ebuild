# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PLICEASE
DIST_VERSION=1.17
inherit perl-module

DESCRIPTION="A Module::Build subclass for building Alien:: modules and their libraries"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

# Alien-Build for Alien::Base::PkgConfig
RDEPEND="
	>=dev-perl/Alien-Build-1.200.0
	dev-perl/Archive-Extract
	>=virtual/perl-Archive-Tar-1.400.0
	>=dev-perl/Capture-Tiny-0.170.0
	>=dev-perl/File-chdir-0.100.500
	>=virtual/perl-HTTP-Tiny-0.44.0
	>=dev-perl/Module-Build-0.400.400
	>=dev-perl/Path-Tiny-0.77.0
	>=virtual/perl-Scalar-List-Utils-1.450.0
	dev-perl/Shell-Config-Generate
	dev-perl/Shell-Guess
	dev-perl/Sort-Versions
	>=virtual/perl-Text-ParseWords-3.260.0
	dev-perl/URI
	virtual/perl-parent
	dev-perl/HTML-Parser
	virtual/perl-JSON-PP
"
DEPEND="
	>=dev-perl/Module-Build-0.400.400
"
# Test2-Suite for Test2::Require::Module and Test2::V0
BDEPEND="
	${RDEPEND}
	test? (
		>=dev-perl/Test2-Suite-0.0.121
	)
"

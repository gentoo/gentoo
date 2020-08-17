# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PLICEASE
DIST_VERSION=2.29
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Build external dependencies for use in CPAN"
SLOT="0"
KEYWORDS="~amd64 ~arm ~s390 ~x86"
IUSE="minimal test zip"
RESTRICT="!test? ( test )"

# No, pkgconfig is not suspect, it actually uses it at runtime, and this module
# is somewhat a wrapper for pkgconfig :/
RDEPEND="
	zip? ( dev-perl/Archive-Zip )
	virtual/perl-Archive-Tar
	>=dev-perl/Capture-Tiny-0.170.0
	virtual/perl-ExtUtils-CBuilder
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	>=virtual/perl-ExtUtils-ParseXS-3.300.0
	>=dev-perl/FFI-CheckLib-0.110.0
	>=dev-perl/File-Which-1.100.0
	dev-perl/File-chdir
	virtual/perl-JSON-PP
	>=dev-perl/Path-Tiny-0.77.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
	>=virtual/perl-Test-Simple-1.302.96
	>=virtual/perl-Text-ParseWords-3.260.0
	virtual/pkgconfig
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Devel-Hide
		>=dev-perl/Test2-Suite-0.0.60
		!minimal? (
			dev-perl/Alien-Base-ModuleBuild
			dev-perl/Sort-Versions
		)
	)
"
src_prepare() {
	unset LD
	[[ -n "${CCLD}" ]] && export LD="${CCLD}"
	perl-module_src_prepare
}

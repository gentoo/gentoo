# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RWSTAUNER
DIST_VERSION=0.927
inherit perl-module

DESCRIPTION="Information about a perl module distribution"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Archive-Tar-1.0.0
	>=dev-perl/Archive-Zip-1.300.0
	>=dev-perl/CPAN-DistnameInfo-0.120.0
	>=virtual/perl-CPAN-Meta-2.100.0
	virtual/perl-Carp
	>=virtual/perl-Digest-1.30.0
	>=virtual/perl-Digest-MD5-2.0.0
	>=virtual/perl-Digest-SHA-5.0.0
	>=dev-perl/File-Spec-Native-1.2.0
	>=virtual/perl-File-Temp-0.190.0
	virtual/perl-Module-Metadata
	>=dev-perl/Path-Class-0.240.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Try-Tiny-0.90.0
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Fatal
		>=dev-perl/Test-MockObject-1.90.0
		>=virtual/perl-Test-Simple-0.960.0
	)
"

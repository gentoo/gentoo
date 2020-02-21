# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=FLORA
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Opaque, extensible XS pointer backed objects using sv_magic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302.0
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
	)
"
src_prepare() {
	sed -i -e 's/use inc::Module::Install /use lib q[.];\nuse inc::Module::Install /' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

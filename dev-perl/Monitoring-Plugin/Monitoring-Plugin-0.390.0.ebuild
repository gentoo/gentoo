# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NIERLEIN
DIST_VERSION=0.39
inherit perl-module

DESCRIPTION="Modules to streamline Nagios, Icinga, Shinken, etc. plugins"

SLOT="0"
KEYWORDS="amd64 hppa sparc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Accessor
	dev-perl/Config-Tiny
	virtual/perl-File-Spec
	dev-perl/Math-Calc-Units
	dev-perl/Params-Validate
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? ( >=virtual/perl-Test-Simple-0.620.0 )
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NIERLEIN
DIST_VERSION=0.40
inherit perl-module

DESCRIPTION="Modules to streamline Nagios, Icinga, Shinken, etc. plugins"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Accessor
	dev-perl/Config-Tiny
	virtual/perl-File-Spec
	dev-perl/Math-Calc-Units
	dev-perl/Params-Validate
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

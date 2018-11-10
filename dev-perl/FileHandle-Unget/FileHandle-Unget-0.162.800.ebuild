# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DCOPPIT
MODULE_VERSION=0.1628
inherit perl-module

DESCRIPTION="A FileHandle which supports ungetting of multiple bytes"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE="test"

RDEPEND=">=virtual/perl-Scalar-List-Utils-1.140.0"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	dev-perl/File-Slurp
	dev-perl/URI
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.];\nuse inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

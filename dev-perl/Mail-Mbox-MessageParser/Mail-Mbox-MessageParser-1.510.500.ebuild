# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DCOPPIT
DIST_VERSION=1.5105
inherit perl-module

DESCRIPTION="A fast and simple mbox folder reader"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/FileHandle-Unget
	virtual/perl-Storable
	dev-perl/File-Slurp
	dev-perl/URI
	dev-perl/Text-Diff
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? ( virtual/perl-Test-Simple )
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

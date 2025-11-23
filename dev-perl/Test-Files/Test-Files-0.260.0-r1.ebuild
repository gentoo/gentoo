# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JSF
DIST_VERSION=0.26
inherit perl-module

DESCRIPTION="A Test::Builder based module to ease testing with files and dirs"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/Class-XSAccessor
	dev-perl/Const-Fast
	dev-perl/Data-Compare
	dev-perl/File-chdir
	dev-perl/PadWalker
	>=dev-perl/Path-Tiny-0.144.0
	dev-perl/Text-Diff
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/File-Copy-Recursive
	test? (
		dev-perl/Test-Expander
	)
"

src_install() {
	perl-module_src_install
	find "${ED}" -type f -name '*.perlcriticrc' -delete || die
}

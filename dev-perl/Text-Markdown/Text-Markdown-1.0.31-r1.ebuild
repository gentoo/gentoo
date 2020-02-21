# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BOBTFISH
DIST_VERSION=1.000031
inherit perl-module

DESCRIPTION="Convert MultiMarkdown syntax to (X)HTML"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-Getopt-Long
	virtual/perl-Text-Balanced
"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
		dev-perl/Text-Diff
		dev-perl/List-MoreUtils
		dev-perl/Test-Differences
		dev-perl/Test-Exception
	)
"

mydoc="Readme.text"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

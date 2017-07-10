# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GUGOD
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="provides '\$self' in OO code"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/B-Hooks-Parser-0.80.0
	>=dev-perl/B-OPCheck-0.270.0
	>=dev-perl/Devel-Declare-0.3.4
	>=dev-perl/PadWalker-1.930.0
	dev-perl/Sub-Exporter
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? ( >=virtual/perl-Test-Simple-0.420.0 )
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DMAKI
DIST_VERSION=1.19
inherit perl-module

DESCRIPTION="A libzmq 3.x wrapper for Perl"

SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	=net-libs/zeromq-3*
	dev-perl/ZMQ-Constants
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	 dev-perl/Task-Weaken
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
	test? (
		dev-perl/Test-Requires
		dev-perl/Test-Fatal
		dev-perl/Test-TCP
		virtual/perl-Test-Simple
	)
"

src_prepare() {
	sed -i -e 's/Otherwise, do the usual./Otherwise, do the usual.\nuse lib q[.];/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

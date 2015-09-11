# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BDFOY
MODULE_VERSION=1.21
inherit perl-module

DESCRIPTION="Cycle through a list of values via a scalar"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-Carp"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		>=virtual/perl-Test-Simple-0.950.0
	)
"

SRC_TEST="do parallel"

src_install() {
	perl-module_src_install
	rm -rf "${ED}"/usr/share/man/
}

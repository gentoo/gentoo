# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Name your accessors get_foo() and set_foo(), whatever that may mean"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE=""

RDEPEND="
	dev-perl/Moose
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"

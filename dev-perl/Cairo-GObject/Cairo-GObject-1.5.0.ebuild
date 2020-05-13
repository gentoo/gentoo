# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=XAOC
DIST_VERSION=1.005
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Integrate Cairo into the Glib type system"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/cairo[glib]
	>=dev-perl/glib-perl-1.224.0
	>=dev-perl/Cairo-1.80.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-Depends-0.200.0
	>=dev-perl/ExtUtils-PkgConfig-1.0.0
"

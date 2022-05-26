# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Simple HTTP router"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 sparc x86"

RDEPEND="
	dev-perl/Class-Accessor-Lite
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( >=virtual/perl-Test-Simple-0.980.0 )
"

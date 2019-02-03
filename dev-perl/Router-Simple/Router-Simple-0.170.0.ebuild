# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Simple HTTP router"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="test"

RDEPEND="
	dev-perl/Class-Accessor-Lite
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( >=virtual/perl-Test-Simple-0.980.0 )
"

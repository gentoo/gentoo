# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=1.002005
inherit perl-module

DESCRIPTION="Import packages into other packages"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND="
	dev-perl/Module-Runtime
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-Test-Simple
	)
"

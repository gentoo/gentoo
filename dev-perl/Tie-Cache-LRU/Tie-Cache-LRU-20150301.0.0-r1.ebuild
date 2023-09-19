# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSCHWERN
DIST_VERSION=20150301
inherit perl-module

DESCRIPTION="A Least-Recently Used cache"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/enum
	dev-perl/Carp-Assert
	dev-perl/Class-Virtual
	dev-perl/Class-Data-Inheritable
"
BDEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.820.0 )
"

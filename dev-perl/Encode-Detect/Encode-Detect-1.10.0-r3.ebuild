# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JGMYERS
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="An Encode::Encoding subclass that detects the encoding of data"

LICENSE="|| ( MPL-1.1 GPL-2+ LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

DEPEND="dev-perl/Module-Build"
BDEPEND="
	dev-perl/Module-Build
	virtual/perl-ExtUtils-CBuilder
"

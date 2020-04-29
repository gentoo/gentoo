# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TJENNESS
DIST_VERSION=3.07
inherit perl-module

DESCRIPTION="Interface to FITS headers"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-perl/Module-Build
"
BDEPEND="
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"

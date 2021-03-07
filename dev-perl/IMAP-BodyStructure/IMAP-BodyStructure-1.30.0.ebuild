# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KAPPA
DIST_VERSION=1.03

inherit perl-module

DESCRIPTION="IMAP4-compatible BODYSTRUCTURE and ENVELOPE parser"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=dev-perl/Module-Build-0.380.0
	test? ( dev-perl/Test-NoWarnings )"

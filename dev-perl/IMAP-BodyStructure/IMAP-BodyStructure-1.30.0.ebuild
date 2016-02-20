# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=KAPPA
DIST_VERSION=1.03

inherit perl-module

DESCRIPTION="IMAP4-compatible BODYSTRUCTURE and ENVELOPE parser"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND=">=dev-perl/Module-Build-0.380.0
	test? ( dev-perl/Test-NoWarnings )"

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="KAPPA"
MODULE_VERSION="1.01"

inherit perl-module

DESCRIPTION="IMAP4-compatible BODYSTRUCTURE and ENVELOPE parser"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Test-NoWarnings
	dev-lang/perl
	dev-perl/Module-Build"

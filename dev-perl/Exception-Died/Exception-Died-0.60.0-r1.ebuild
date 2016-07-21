# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DEXTER
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Convert simple die into real exception object"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/constant-boolean
	>=dev-perl/Exception-Base-0.22.01"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
#	test? ( virtual/perl-parent
#		>=dev-perl/Test-Unit-Lite-0.12
#		>=dev-perl/Test-Assert-0.0501 )"

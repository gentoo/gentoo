# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Config-Any/Config-Any-0.260.0.ebuild,v 1.2 2015/06/13 18:48:05 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BRICAS
MODULE_VERSION=0.26
inherit perl-module

DESCRIPTION="Load configuration from different file formats, transparently"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	>=dev-perl/Module-Pluggable-3.10.0
	!<dev-perl/config-general-2.47
	!<dev-perl/Config-General-2.47
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do

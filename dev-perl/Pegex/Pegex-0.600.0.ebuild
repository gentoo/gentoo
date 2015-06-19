# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Pegex/Pegex-0.600.0.ebuild,v 1.1 2015/02/25 22:36:22 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=INGY
MODULE_VERSION=0.60
inherit perl-module

DESCRIPTION="Acmeist PEG Parser Framework"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? ( dev-perl/YAML-LibYAML )
"

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Config-Properties/Config-Properties-1.770.0.ebuild,v 1.1 2015/05/01 20:40:53 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=SALVA
MODULE_VERSION=1.77
inherit perl-module

DESCRIPTION="Configuration using Java style properties"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-File-Temp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do

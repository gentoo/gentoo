# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_AUTHOR=MIK
MODULE_VERSION=0.025
inherit perl-module

DESCRIPTION="Self-contained crypto toolkit"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Exporter-5.590.0
	>=dev-perl/JSON-2.10.0
	>=virtual/perl-MIME-Base64-3.110.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	dev-perl/Module-Build
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"

SRC_TEST="do parallel"

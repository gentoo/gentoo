# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=REHSACK
MODULE_VERSION=1.407
inherit perl-module

DESCRIPTION="Small SQL parser and engine"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Clone-0.30
	virtual/perl-Data-Dumper
	dev-perl/Module-Runtime
	>=dev-perl/Params-Util-1.0.0
	>=virtual/perl-Scalar-List-Utils-1.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/Math-Base-Convert
	)
"

SRC_TEST="do parallel"

#pkg_setup() {
#	export SQL_STATEMENT_WARN_UPDATE=sure
#}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_AUTHOR="PEVANS"
MODULE_VERSION="0.22"

inherit perl-module

DESCRIPTION="Address-family independent name resolving functions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=">=dev-perl/ExtUtils-CChecker-0.60.0
	virtual/perl-ExtUtils-CBuilder
	dev-perl/Module-Build
	virtual/perl-Scalar-List-Utils
	virtual/perl-XSLoader
	test? ( virtual/perl-Test-Simple )
"
RDEPEND="virtual/perl-Exporter
	 virtual/perl-Socket"
PERL_RM_FILES=( t/99pod.t )
SRC_TEST="do"

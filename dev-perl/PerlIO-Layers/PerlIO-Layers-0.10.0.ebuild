# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="LEONT"
MODULE_VERSION=0.010

inherit perl-module

DESCRIPTION="Querying your filehandle's capabilities"

SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"

# needs List::Util
RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
	dev-perl/List-MoreUtils
	virtual/perl-Scalar-List-Utils
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.820.0
	)
"

SRC_TEST="do parallel"

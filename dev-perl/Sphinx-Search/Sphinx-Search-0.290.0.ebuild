# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JJSCHUTZ
MODULE_VERSION=0.29
inherit perl-module

DESCRIPTION="Perl API client for Sphinx search engine"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Accessor
	dev-perl/DBI
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	dev-perl/File-SearchPath
	virtual/perl-Scalar-List-Utils
	virtual/perl-Math-BigInt
	dev-perl/Path-Class
	virtual/perl-Socket
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"

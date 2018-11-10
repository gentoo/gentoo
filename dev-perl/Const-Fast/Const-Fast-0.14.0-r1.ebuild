# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=LEONT
MODULE_VERSION=0.014
inherit perl-module

DESCRIPTION="Facility for creating read-only scalars, arrays, and hashes"

SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	virtual/perl-Scalar-List-Utils
	virtual/perl-Storable
	>=dev-perl/Sub-Exporter-Progressive-0.1.7
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.21.0
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Temp
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"

SRC_TEST=do
mytargets="install"

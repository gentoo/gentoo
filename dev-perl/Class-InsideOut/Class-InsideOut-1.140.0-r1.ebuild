# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.14
inherit perl-module

DESCRIPTION="Safe, simple inside-out object construction kit"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-ISA
	virtual/perl-Exporter
	>=virtual/perl-Scalar-List-Utils-1.90.0
	virtual/perl-Storable
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.45
		virtual/perl-XSLoader
	)
"

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAMS
DIST_VERSION=0.32
inherit perl-module

DESCRIPTION="PerlIO layer that adds read & write timeout to a handle"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-Time-HiRes
"
DEPEND="
	>=dev-perl/Module-Build-Tiny-0.39.0
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Test-Simple
		dev-perl/Test-TCP
	)
"

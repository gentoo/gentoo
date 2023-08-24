# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SCHUBIGER
DIST_VERSION=1.17
inherit perl-module

DESCRIPTION="Parse informal natural language date/time strings"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Clone
	dev-perl/Date-Calc
	dev-perl/DateTime
	dev-perl/DateTime-HiRes
	dev-perl/DateTime-TimeZone
	virtual/perl-Exporter
	virtual/perl-Getopt-Long
	dev-perl/List-MoreUtils
	>=dev-perl/Params-Validate-1.150.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-Storable
	virtual/perl-Term-ReadLine
	dev-perl/boolean
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		dev-perl/Module-Util
		dev-perl/Test-MockTime-HiRes
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod.t
)

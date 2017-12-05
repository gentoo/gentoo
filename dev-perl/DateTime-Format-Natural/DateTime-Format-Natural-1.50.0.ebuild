# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SCHUBIGER
DIST_VERSION=1.05
inherit perl-module

DESCRIPTION="Parse informal natural language date/time strings"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Clone
	dev-perl/Date-Calc
	dev-perl/DateTime
	dev-perl/DateTime-TimeZone
	virtual/perl-Exporter
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	dev-perl/List-MoreUtils
	dev-perl/Params-Validate
	virtual/perl-Scalar-List-Utils
	virtual/perl-Storable
	virtual/perl-Term-ReadLine
	dev-perl/boolean
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		dev-perl/Module-Util
		dev-perl/Test-MockTime
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="KRYDE"
DIST_VERSION=0.40
inherit perl-module

DESCRIPTION="Factorize numbers and calculate matching multiplications"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="test"

RDEPEND="dev-perl/boolean
	dev-perl/List-MoreUtils
	dev-perl/Params-Validate
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
	virtual/perl-XSLoader"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	virtual/perl-ExtUtils-CBuilder
	test? ( virtual/perl-Test-Simple )"

src_test() {
	perl_rm_files "t/pod.t" "t/pod-coverage.t"
	perl-module_src_test
}

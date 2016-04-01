# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="KRYDE"
DIST_VERSION=0.26
inherit perl-module

DESCRIPTION="Detect and calculate prime numbers with deterministic tests"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/boolean
	dev-perl/Params-Validate
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
	virtual/perl-XSLoader"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? ( virtual/perl-Test-Simple )
	virtual/perl-ExtUtils-CBuilder"

src_test() {
	perl_rm_files "t/pod.t" "t/pod-coverage.t"
	perl-module_src_test
}

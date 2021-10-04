# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AMBS
DIST_VERSION=0.69
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A perl XML down translate module"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/HTTP-Simple
	virtual/perl-Scalar-List-Utils
	>=dev-perl/XML-DTDParser-2.0.0
	>=dev-perl/XML-LibXML-1.540.0
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=virtual/perl-Test-Simple-0.400.0
	)
"

src_test() {
	perl_rm_files t/pod{,-coverage}.t
	perl-module_src_test
}

# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHANSEN
DIST_VERSION=0.62
inherit perl-module

DESCRIPTION="Encoding and decoding of UTF-8 encoding form"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=virtual/perl-Encode-1.980.100
		>=dev-perl/Test-Fatal-0.6.0
		>=virtual/perl-Test-Simple-0.470.0

		dev-perl/Taint-Runtime
		dev-perl/Variable-Magic
		dev-perl/Test-LeakTrace
	)
"
src_test() {
	perl_rm_files t/999_pod.t
	perl-module_src_test
}

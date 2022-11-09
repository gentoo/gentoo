# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FLORA
DIST_VERSION=1.2
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Set up a CGI environment from an HTTP::Request"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Accessor
	>=dev-perl/HTTP-Message-1.530.0
	virtual/perl-IO
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	perl_rm_files "t/release-pod-syntax.t" "t/release-pod-coverage.t"
	perl-module_src_test
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DCONWAY
DIST_VERSION=0.997004
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Interactively prompt for user input"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-IO
	dev-perl/TermReadKey
	dev-perl/Want
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files "t/pod.t" "t/pod-coverage.t"
	perl-module_src_test
}

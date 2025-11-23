# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.13
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A simple command-line shell framework"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=virtual/perl-Getopt-Long-2.360.0
	dev-perl/TermReadKey
	dev-perl/Text-Autoformat
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
"

src_test() {
	perl_rm_files t/author-pod-syntax.t t/cpan-changes.t t/release-cpan-changes.t t/pod.t \
		t/release-kwalitee.t t/release-trailing-space.t t/style-trailing-space.t
	perl-module_src_test
}

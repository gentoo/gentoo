# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=1.002
inherit perl-module

DESCRIPTION="Object and functions to work with International Standard Serial Numbers"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( virtual/perl-Test-Simple )
"

src_install() {
	perl-module_src_install
	rm -rf "${ED}"/usr/share/man || die
}

src_test() {
	perl_rm_files t/pod.t t/pod_coverage.t
	perl-module_src_test
}

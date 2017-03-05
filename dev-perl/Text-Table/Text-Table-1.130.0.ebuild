# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SHLOMIF
MODULE_VERSION=1.130
inherit perl-module

DESCRIPTION="Organize Data in Tables"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Text-Aligner-0.50.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	virtual/perl-Scalar-List-Utils
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"

src_install() {
	perl-module_src_install
	docinto examples
	docompress -x /usr/share/doc/${PF}/examples
	dodoc examples/Text-Table-UTF8-example.pl
}

src_test() {
	perl_rm_files t/pod-coverage.t t/style-trailing-space.t \
		t/cpan-changes.t t/pod.t
	perl-module_src_test
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=3.0612
inherit perl-module

DESCRIPTION="Module of basic descriptive statistical functions"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test examples"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/List-MoreUtils
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	test? ( virtual/perl-Test-Simple )
"
mydoc="UserSurvey.txt"

src_test() {
	perl_rm_files "t/pod-coverage.t" "t/pod.t" "t/cpan-changes.t" "t/style-trailing-space.t"
	perl-module_src_test
}
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples/
		dodoc -r examples
	fi
}

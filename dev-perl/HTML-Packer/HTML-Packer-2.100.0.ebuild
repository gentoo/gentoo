# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LEEJO
DIST_VERSION=2.10
inherit perl-module

DESCRIPTION="Another HTML code cleaner"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/CSS-Packer-2.10.0
	virtual/perl-Digest-SHA
	>=dev-perl/JavaScript-Packer-2.10.0
	>=dev-perl/Regexp-RegGrp-1.1.1_rc
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}

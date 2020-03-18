# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DANBORN
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Query a Google SafeBrowsing table"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/URI
	>=virtual/perl-Math-BigInt-1.87
	virtual/perl-DB_File
	|| (
		virtual/perl-Math-BigInt-FastCalc
		dev-perl/Math-BigInt-GMP
	)"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}

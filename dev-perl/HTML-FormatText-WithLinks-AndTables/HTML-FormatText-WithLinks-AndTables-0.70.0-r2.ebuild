# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DALEEVANS
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Converts HTML to text with tables intact"

SLOT="0"
KEYWORDS="amd64 ~riscv"

RDEPEND="
	dev-perl/HTML-Formatter
	dev-perl/HTML-FormatText-WithLinks
	dev-perl/HTML-Tree
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

PATCHES=( "${FILESDIR}/README-INC.patch" )

src_test() {
	perl_rm_files t/author-*.t t/pod.t t/boilerplate.t
	perl-module_src_test
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DALEEVANS
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Converts HTML to text with tables intact"

SLOT="0"
KEYWORDS="amd64"
IUSE="test"

PATCHES=( "${FILESDIR}/README-INC.patch" )
RDEPEND="
	dev-perl/HTML-Format
	dev-perl/HTML-FormatText-WithLinks
	dev-perl/HTML-Tree
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/author-*.t t/pod.t t/boilerplate.t
	perl-module_src_test
}

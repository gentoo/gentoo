# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TRIZEN
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="Perl module to get and parse the Linux .desktop files"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-lang/perl-5.14.0"
DEPEND="dev-perl/Module-Build"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}

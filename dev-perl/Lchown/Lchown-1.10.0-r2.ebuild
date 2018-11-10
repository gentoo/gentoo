# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NCLEATON
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Use the lchown(2) system call from Perl"

SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-perl/Module-Build"
src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}

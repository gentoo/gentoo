# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DAVECROSS
MODULE_VERSION=2.02
inherit perl-module

DESCRIPTION="Perl extension for comparing arrays"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

SRC_TEST="do"

RDEPEND="dev-perl/Moose"
DEPEND=">=dev-perl/Module-Build-0.28
	test? ( ${RDEPEND}
		dev-perl/Test-NoWarnings
	)"

src_test() {
	perl_rm_files t/pod.t t/pod_coverage.t
	perl-module_src_test
}

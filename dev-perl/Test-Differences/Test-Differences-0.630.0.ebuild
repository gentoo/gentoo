# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DCANTRELL
MODULE_VERSION=0.63
inherit perl-module

DESCRIPTION="Test strings and data structures and show differences if not ok"

SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Text-Diff
	>=virtual/perl-Data-Dumper-2.126.0"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	dev-perl/Capture-Tiny
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST=do

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}

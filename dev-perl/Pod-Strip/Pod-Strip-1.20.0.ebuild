# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DOMM
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION="Remove POD from Perl code"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Pod-Simple-3.0.0
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST=do

src_test() {
	perl_rm_files t/99_pod.t t/99_pod_coverage.t
	perl-module_src_test
}

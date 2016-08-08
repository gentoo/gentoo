# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RCLAMP
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Perl module to parse vFile formatted files into data structures"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Class-Accessor-Chained"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}

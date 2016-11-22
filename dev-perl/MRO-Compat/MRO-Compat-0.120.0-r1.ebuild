# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BOBTFISH
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Lets you build groups of accessors"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~ppc-aix ~x86-fbsd ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test"

RDEPEND="
"
#	>=dev-perl/Class-C3-0.20
#	>=dev-perl/Class-C3-XS-0.08
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST=do

src_test() {
	perl_rm_files t/02pod.t t/03pod_coverage.t
	perl-module_src_test
}

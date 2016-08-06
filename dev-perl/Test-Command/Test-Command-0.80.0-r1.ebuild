# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DANBOO
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Test routines for external commands"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}

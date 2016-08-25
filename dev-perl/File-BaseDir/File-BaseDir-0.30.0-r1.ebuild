# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PARDUS
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="Use the Freedesktop.org base directory specification"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)"

SRC_TEST=do

src_test() {
	perl_rm_files t/05_pod_cover.t t/04_pod_ok.t
	perl-module_src_test
}

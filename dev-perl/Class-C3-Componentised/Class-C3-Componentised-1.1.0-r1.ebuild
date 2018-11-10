# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=FREW
MODULE_VERSION=1.001000
inherit perl-module

DESCRIPTION="Load mix-ins or components to your C3-based class"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND="dev-perl/MRO-Compat
	dev-perl/Class-Inspector
	>=dev-perl/Class-C3-0.20"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Exception
	)"

SRC_TEST=do

src_prepare() {
	sed -i -e 's/use inc::Module::Install /use lib q[.];\nuse inc::Module::Install /' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}

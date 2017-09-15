# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ADAMK
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Implements a flat filesystem"

SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=">=dev-perl/Class-Autouse-1
	>=dev-perl/Test-ClassAPI-1.02
	>=dev-perl/File-Copy-Recursive-0.36
	>=dev-perl/File-Remove-0.38
	>=virtual/perl-File-Spec-0.85
	>=virtual/perl-File-Temp-0.17
	>=dev-perl/File-Remove-0.21
	>=dev-perl/File-Slurp-9999.04
	>=dev-perl/prefork-0.02"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

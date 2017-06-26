# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=AUTRIJUS
MODULE_VERSION=0.63
inherit perl-module

DESCRIPTION="Automatic installation of dependencies via CPAN from within Makefile.PL"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

# TESTS BAD. Wants to write to cpan's config on the live system
#SRC_TEST="do"

RDEPEND="dev-perl/Sort-Versions"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.];\nuse inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

src_compile() {
	echo "n" | perl-module_src_compile
}

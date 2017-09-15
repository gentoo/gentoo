# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=Class-ReturnValue
MODULE_AUTHOR=JESSE
MODULE_VERSION=0.55
inherit perl-module

DESCRIPTION="A return-value object that lets you treat it as as a boolean, array or object"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND="dev-perl/Devel-StackTrace"
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

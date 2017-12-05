# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MITHALDU
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Diffie-Hellman key exchange system"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~x86"
IUSE=""

RDEPEND="
	dev-libs/gmp
	dev-perl/Math-BigInt-GMP
	>=virtual/perl-Math-BigInt-1.60
	dev-perl/Crypt-Random
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

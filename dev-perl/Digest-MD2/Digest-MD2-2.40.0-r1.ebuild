# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GAAS
DIST_VERSION=2.04
inherit perl-module

DESCRIPTION="Perl interface to the MD2 Algorithm"
LICENSE="|| ( Artistic GPL-1+ ) RSA"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

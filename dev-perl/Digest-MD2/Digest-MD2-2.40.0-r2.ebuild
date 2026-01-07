# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GAAS
DIST_VERSION=2.04
inherit perl-module

DESCRIPTION="Perl interface to the MD2 Algorithm"
LICENSE="|| ( Artistic GPL-1+ ) RSA"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc x86"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

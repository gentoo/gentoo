# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=VIPUL
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl version of Nilsimsa code"

# Bug: https://rt.cpan.org/Ticket/Display.html?id=133085
LICENSE="GPL-2+ LGPL-2"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}"/${PN}-0.60.0-clang16.patch
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

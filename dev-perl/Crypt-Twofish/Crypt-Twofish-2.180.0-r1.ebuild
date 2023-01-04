# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=AMS
DIST_VERSION=2.18
inherit perl-module

DESCRIPTION="The Twofish Encryption Algorithm"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

PATCHES=(
	"${FILESDIR}"/${PN}-2.180.0-configure-clang16.patch
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

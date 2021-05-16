# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=AMS
DIST_VERSION=2.17
inherit perl-module

DESCRIPTION="The Twofish Encryption Algorithm"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

PATCHES=("${FILESDIR}/no-dot-inc.patch")

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

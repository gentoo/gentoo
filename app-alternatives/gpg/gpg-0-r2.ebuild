# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"reference:>=app-crypt/gnupg-2.4.8-r1[alternatives(-),nls?,ssl?]"
)

inherit app-alternatives

DESCRIPTION="gpg symlink"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="nls ssl"

RDEPEND="
	!app-crypt/gnupg[-alternatives(-)]
"

src_install() {
	local alt=$(get_alternative)

	dodir /usr/bin
	dosym "gpg-${alt}" /usr/bin/gpg
	dosym "gpgv-${alt}" /usr/bin/gpgv
	dosym gpg /usr/bin/gpg2
	dosym gpgv /usr/bin/gpgv2
}

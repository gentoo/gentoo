# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"reference:>=app-crypt/gnupg-2.4.8-r1[alternatives(-),nls?,ssl?]"
)

inherit app-alternatives

DESCRIPTION="gpg symlink"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="nls ssl"

RDEPEND="
	!app-crypt/gnupg[-alternatives(-)]
	!=app-crypt/gnupg-2.4.8-r1
	!=app-crypt/gnupg-2.5.13-r1
"

src_install() {
	local alt=$(get_alternative)

	dodir /usr/bin
	dosym "gpg-${alt}" /usr/bin/gpg
	dosym "gpgv-${alt}" /usr/bin/gpgv
	dosym gpg /usr/bin/gpg2
	dosym gpgv /usr/bin/gpgv2

	newman - gpg.1 <<<".so gpg-${alt}.1"
	newman - gpgv.1 <<<".so gpgv-${alt}.1"
	newman - gpg2.1 <<<".so gpg.1"
	newman - gpgv2.1 <<<".so gpgv.1"
}

# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"reference:>=app-crypt/gnupg-2.4.8-r2[alternatives(-),nls?,ssl?]"
	"freepg:>=app-crypt/freepg-2.5.12_p1-r1[nls?,ssl?]"
	"sequoia:>=app-crypt/sequoia-chameleon-gnupg-0.13.1-r3"
)

inherit app-alternatives

DESCRIPTION="gpg symlink"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="nls ssl"

RDEPEND="
	!app-crypt/gnupg[-alternatives(-)]
	!=app-crypt/freepg-2.5.12_p1-r0
	!=app-crypt/gnupg-2.4.8-r1
	!=app-crypt/gnupg-2.5.13-r1
"

src_install() {
	local alt=$(get_alternative)

	case ${alt} in
		sequoia)
			alt=sq
			;;
	esac

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

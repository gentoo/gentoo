# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by the netfilter project"
HOMEPAGE="https://www.netfilter.org/"
SRC_URI="
	https://www.netfilter.org/files/coreteam-gpg-key-26D292E4.txt
		-> netfilter-gpg-26D292E4.txt
	https://www.netfilter.org/files/coreteam-gpg-key-2D0987E6.txt
		-> netfilter-gpg-2D0987E6.txt
	https://www.netfilter.org/files/coreteam-gpg-key-BB5F58CC.txt
		-> netfilter-gpg-BB5F58CC.txt
	https://www.netfilter.org/files/coreteam-gpg-key-0xD55D978A8A1420E4.txt
		-> netfilter-gpg-0xD55D978A8A1420E4.txt
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - netfilter.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

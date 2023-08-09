# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Jia Tan"
HOMEPAGE="https://tukaani.org/xz/"
SRC_URI="https://tukaani.org/misc/jia_tan_pubkey.txt"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - jiatan.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

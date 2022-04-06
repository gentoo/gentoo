# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Lasse Collin"
HOMEPAGE="https://tukaani.org/xz/"
SRC_URI="https://tukaani.org/misc/lasse_collin_pubkey.txt -> ${P}-lasse_collin_pubkey.txt"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - lassecollin.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

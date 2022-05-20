# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Vinay Sajip"
HOMEPAGE="https://github.com/vsajip/python-gnupg"
SRC_URI="https://keys.openpgp.org/vks/v1/by-fingerprint/CA749061914EAC138E66EADB9147B477339A9B86"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - vinaysajip.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

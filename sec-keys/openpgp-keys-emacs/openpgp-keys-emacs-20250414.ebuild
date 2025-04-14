# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Stefan Kangas' OpenPHP keys used for signing GNU Emacs releases"
HOMEPAGE="https://www.gnu.org/software/emacs/"
SRC_URI="https://keys.openpgp.org/vks/v1/by-fingerprint/CEA1DE21AB108493CC9C65742E82323B8F4353EE"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - ${PN/openpgp-keys-/}.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

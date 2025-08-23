# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Nicholas Wilson"
HOMEPAGE="https://github.com/NWilson"
# Grabbed from https://keyserver.ubuntu.com/pks/lookup?search=A95536204A3BB489715231282A98E77EB6F24CA8&fingerprint=on&op=index because gh lacks a subuid + sigs
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-20250209-0xA95536204A3BB489715231282A98E77EB6F24CA8.asc"
#SRC_URI="https://github.com/NWilson.gpg -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - nicholaswilson.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

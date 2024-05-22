# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key used by Jari Ruusu"
HOMEPAGE="https://loop-aes.sourceforge.net/"
SRC_URI="https://loop-aes.sourceforge.net/PGP-public-key.asc -> ${P}.asc"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc sparc x86"

src_unpack() {
	:
}

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}/${P}.asc" jariruusu.asc
}

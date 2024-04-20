# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign mkvtoolnix releases"
HOMEPAGE="https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt"
SRC_URI="https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - mkvtoolnix.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

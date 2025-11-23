# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Ondrej Jirman"
HOMEPAGE="https://xff.cz/megatools/"
SRC_URI="
	https://xff.cz/key.txt
		-> ondrejjirman-${PV}-EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - ondrejjirman.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Pavel Hrdina's OpenPGP keys used to sign virt-manager since version 5.0.0"
HOMEPAGE="https://virt-manager.org"
# Grabbed from https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x4252d86a52041137c291cadfc85c5e957062a701
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-0x4252d86a52041137c291cadfc85c5e957062a701.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - virt-manager.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

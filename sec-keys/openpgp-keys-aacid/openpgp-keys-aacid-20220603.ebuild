# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Albert Astals Cid"
HOMEPAGE="https://poppler.freedesktop.org/"
# Mirrored from https://pgp.surfnet.nl/pks/lookup?op=get&search=0xCA262C6C83DE4D2FB28A332A3A6A4DB839EAA6D7
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-0xCA262C6C83DE4D2FB28A332A3A6A4DB839EAA6D7.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - aacid.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

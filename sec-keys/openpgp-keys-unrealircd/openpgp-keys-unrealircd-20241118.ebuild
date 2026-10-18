# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign UnrealIRCd releases"
HOMEPAGE="https://www.unrealircd.org/"
SRC_URI="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x36E6F65706E36B0937280299101001DAF48BB56D -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - unrealircd.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

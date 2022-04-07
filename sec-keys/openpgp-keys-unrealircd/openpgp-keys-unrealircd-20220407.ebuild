# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# https://www.unrealircd.org/download/6.0/6.0.2/src
MY_COMMIT="0fd9c2ee6fafe1e8b8ed8b69bf73dded47c8b01a"
DESCRIPTION="OpenPGP keys used to sign UnrealIRCd releases"
HOMEPAGE="https://github.com/unrealircd/unrealircd/blob/unreal60_dev/doc/KEYS"
# https://www.unrealircd.org/downloads/release_key.gpg
SRC_URI="https://raw.githubusercontent.com/unrealircd/unrealircd/${MY_COMMIT}/doc/KEYS -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - unrealircd.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

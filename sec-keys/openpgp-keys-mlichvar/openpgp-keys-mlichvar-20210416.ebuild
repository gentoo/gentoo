# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Miroslav Lichvar"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://chrony.tuxfamily.org/gpgkey-8B1F4A9ADA73D401E3085A0B5FF06F29BA1E013B.asc -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - mlichvar.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

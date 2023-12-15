# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign MySQL releases"
HOMEPAGE="https://dev.mysql.com/doc/refman/8.4/en/checking-gpg-signature.html"
SRC_URI="https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - mysql.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

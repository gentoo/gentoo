# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign Stellarium releases"
HOMEPAGE="https://stellarium.org/ https://github.com/Stellarium/stellarium"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"

S="${WORKDIR}"

src_install() {
	local files=( "${FILESDIR}"/stellarium.asc )
	insinto /usr/share/openpgp-keys
	newins - stellarium.asc < <(cat "${files[@]}" || die)
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key used to sign Xpdf releases"
HOMEPAGE="https://www.xpdfreader.com"
SRC_URI="https://www.xpdfreader.com/gpg-key.txt -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - xpdf.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

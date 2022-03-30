# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Guillem Jover"
HOMEPAGE="https://www.hadrons.org/~guillem/"
SRC_URI="https://www.hadrons.org/~guillem/guillem-4F3E74F436050C10F5696574B972BF3EA4AE57A3.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - guillemjover.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by the Wayne Davison"
HOMEPAGE="https://opencoder.net/"
SRC_URI="
	https://opencoder.net/WayneDavison.key
		-> waynedavison-0048C8B026D4C96F0E589C2F6C859FB14B96A8C5.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - waynedavison.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

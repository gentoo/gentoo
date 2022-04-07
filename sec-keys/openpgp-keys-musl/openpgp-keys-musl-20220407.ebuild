# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign musl"
HOMEPAGE="https://musl.libc.org/releases.html"
SRC_URI="https://musl.libc.org/musl.pub -> ${P}.pub"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - musl.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

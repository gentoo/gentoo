# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by Daniel Stenberg"
HOMEPAGE="https://daniel.haxx.se/"
# see https://daniel.haxx.se/address.html
SRC_URI="
	https://daniel.haxx.se/mykey.asc
		-> danielstenberg-27EDEAF22F3ABCEB50DB9A125CC908FDB71E12C2.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - danielstenberg.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

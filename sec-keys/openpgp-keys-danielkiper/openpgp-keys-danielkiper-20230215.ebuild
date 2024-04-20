# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Daniel Kiper"
# I can't find a home page for him, so I'm just gonna put GRUB's since that's
# currently his baby.
# - xxc3nsoredxx
HOMEPAGE="https://www.gnu.org/software/grub/"
SRC_URI="
	https://openpgpkey.net-space.pl/.well-known/openpgpkey/net-space.pl/hu/9b7hhehhfsjjw6h7bfzdesyjrhqhwgaq?l=dkiper
		-> ${P}.gpg
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - dkiper.gpg < <(cat "${files[@]/#/${DISTDIR}/}")
}

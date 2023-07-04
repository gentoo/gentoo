# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by the libevent project"
HOMEPAGE="https://libevent.org/"
SRC_URI="
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9e3ac83a27974b84d1b3401db86086848ef8686d
		-> ${P}-azat-khuzhin.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - libevent.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

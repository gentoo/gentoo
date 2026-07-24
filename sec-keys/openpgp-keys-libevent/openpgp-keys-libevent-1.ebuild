# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by the libevent project"
HOMEPAGE="https://libevent.org/"
SRC_URI="
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9e3ac83a27974b84d1b3401db86086848ef8686d
		-> ${P}-azat-khuzhin.asc
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2133bc600ab133e1d826d173fe43009c4607b1fb
		-> ${P}-nick-mathewson.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - libevent.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

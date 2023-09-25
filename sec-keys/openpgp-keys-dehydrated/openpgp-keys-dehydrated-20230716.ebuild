# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by dehydrated"
HOMEPAGE="https://dehydrated.io/"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/3C2F2605E078A1E18F4793909C4DBE6CF438F333
		-> dehydrated-3C2F2605E078A1E18F4793909C4DBE6CF438F333.asc
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - dehydrated.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign Openwall software releases"
HOMEPAGE="https://www.openwall.com/signatures/"
SRC_URI="
	https://www.openwall.com/signatures/openwall-offline-signatures.asc ->
		297AD21CF86C948081520C1805C027FD4BDC136E.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - openwall.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}

# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign voikko* packages"
HOMEPAGE="https://voikko.puimula.org/"
SRC_URI="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xac5d65f10c8596d7e2dae2633d309b604ae3942e -> ${P}-4ae3942e.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - voikko.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

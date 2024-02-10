# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign LXC-related packages"
HOMEPAGE="https://linuxcontainers.org/"
SRC_URI="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x4880b8c9bd0e5106fc070f4f7b3c391efea93624 -> FEA93624.asc
	https://keyserver.ubuntu.com/pks/lookup?op=hget&search=32873a3b691d14a1b2b2e09a7fb6ee0d -> 64792D67.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - linuxcontainers.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

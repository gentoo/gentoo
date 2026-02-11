# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign glibc releases"
HOMEPAGE="https://sourceware.org/glibc/wiki/SSDLC/Policy/glibc"

# this is a workaround until a better source exists
SRC_URI="https://www.akhuettel.de/key-atwork.txt -> ${P}.asc"

S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - glibc.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}

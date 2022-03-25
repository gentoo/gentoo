# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by the libarchive project"
HOMEPAGE="https://www.libarchive.org/"
SRC_URI="
	https://keys.openpgp.org/vks/v1/by-fingerprint/A5A45B12AD92D964B89EEE2DEC560C81CEC2276E
		-> libarchive-A5A45B12AD92D964B89EEE2DEC560C81CEC2276E.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - libarchive.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by OpenSSH"
HOMEPAGE="https://www.openssh.org/"
# Listed on https://www.openssh.org/portable.html
SRC_URI="
	https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/RELEASE_KEY.asc
		-> openssh-7168B983815A5EEF59A4ADFD2A3F414E736060BA.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - openssh.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

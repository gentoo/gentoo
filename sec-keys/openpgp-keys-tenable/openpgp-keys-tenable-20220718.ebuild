# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign Tenable Inc. software packages"
HOMEPAGE="https://www.tenable.com/"
# Current key, used to sign Nessus releases since 10.4 and Nessus Agent releases since 10.2
SRC_URI="
	https://www.tenable.com/downloads/api/v2/pages/nessus/files/tenable-4096.gpg
		-> tenable-9E53A34068D18A6E0EE45E41A021B5142F12969D.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - tenable.com.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

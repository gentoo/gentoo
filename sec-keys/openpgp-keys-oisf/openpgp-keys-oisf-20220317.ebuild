# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by the Open Information Security Foundation"
HOMEPAGE="https://oisf.net/"
SRC_URI="
	https://www.openinfosecfoundation.org/download/OISF.pub
		-> oisf-B36FDAF2607E10E8FFA89E5E2BA9C98CCDF1E93A.asc
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - oisf.net.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key used by Open InfoSec Foundation (OISF) software releases"
HOMEPAGE="https://www.openinfosecfoundation.org/"
SRC_URI="https://www.openinfosecfoundation.org/download/OISF.pub
	-> oisf-B36FDAF2607E10E8FFA89E5E2BA9C98CCDF1E93A.asc"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

S="${WORKDIR}"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - openinfosecfoundation.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

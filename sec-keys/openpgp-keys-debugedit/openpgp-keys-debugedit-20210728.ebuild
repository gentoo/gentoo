# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP key used to sign debugedit releases"
HOMEPAGE="https://sourceware.org/debugedit/"
SRC_URI="
	https://sourceware.org/ftp/debugedit/gpgkey-5C1D1AA44BE649DE760A.gpg
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - debugedit.gpg < <(cat "${files[@]/#/${DISTDIR}/}")
}

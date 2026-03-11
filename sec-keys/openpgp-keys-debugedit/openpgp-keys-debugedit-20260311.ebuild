# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP key used to sign debugedit releases"
HOMEPAGE="https://sourceware.org/debugedit/"
SRC_URI="
	https://www.klomp.org/mark/gnupg-pub.txt
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - debugedit.gpg < <(cat "${files[@]/#/${DISTDIR}/}")
}

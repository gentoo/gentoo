# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign Linux kernel releases"
HOMEPAGE="https://www.kernel.org/signature.html"
SRC_URI="
	https://kernel.org/.well-known/openpgpkey/hu/e3n9xnm94c5apezqnj1pmrfuaoyfm8cf?l=gregkh
		-> gregkh@kernel.org.key
	https://kernel.org/.well-known/openpgpkey/hu/pf113mfnx1f3eb1yiwhsipa91xfc7o4x?l=torvalds
		-> torvalds@kernel.org.key
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

S=${WORKDIR}

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - kernel.org.asc < <(cat "${files[@]/#/${DISTDIR}/}")
}

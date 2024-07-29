# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by the sysvinit project"
HOMEPAGE="https://savannah.nongnu.org/projects/sysvinit https://github.com/slicer69/sysvinit"
#https://github.com/slicer69/sysvinit/commit/5eee38102bc1ebf21f4546c2973509924d08d251
#SRC_URI="https://savannah.nongnu.org/project/memberlist-gpgkeys.php?group=sysvinit&download=1 -> ${P}.asc"
SRC_URI="https://download.savannah.nongnu.org/releases/sysvinit/sysvinit-verification-key-2.pub -> ${P}-key-2.asc
	https://download.savannah.nongnu.org/releases/sysvinit/sysvinit-verification-key-3.pub -> ${P}-key-3.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - sysvinit.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

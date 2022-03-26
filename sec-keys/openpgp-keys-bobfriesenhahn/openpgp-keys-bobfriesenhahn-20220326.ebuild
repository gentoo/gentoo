# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Bob Friesenhahn"
HOMEPAGE="http://www.simplesystems.org/users/bfriesen/"
# http://www.graphicsmagick.org/security.html
SRC_URI="http://www.simplesystems.org/users/bfriesen/public-key.txt -> ${P}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - bobfriesenhahn.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}

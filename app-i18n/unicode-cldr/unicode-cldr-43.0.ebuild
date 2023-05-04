# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Unicode Common Locale Data Repository"
HOMEPAGE="https://cldr.unicode.org/"
SRC_URI="https://unicode.org/Public/${PN#*-}/${PV%.0}/${PN#*-}-common-${PV}.zip -> ${PN}-common-${PV}.zip"

LICENSE="unicode"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

RDEPEND=""
BDEPEND="app-arch/unzip"
S="${WORKDIR}"

src_install() {
	insinto /usr/share/${PN/-//}
	doins -r common
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Get SD-card health data"
HOMEPAGE="https://www.ogi-it.com/portfolio/sdmon/ https://github.com/Ognian/sdmon"

MY_COMMIT_ID="9ab840a15bbd93dd4e2797ecc47f8d2362ef2785"
SRC_URI="
	https://github.com/Ognian/sdmon/archive/${MY_COMMIT_ID}.tar.gz
		-> ${P}.tar.gz
"

S="${WORKDIR}/${PN}-${MY_COMMIT_ID}/src"

LICENSE="GPL-2 BSD-2"
SLOT="0"

KEYWORDS="~amd64 ~arm64"

src_install() {
	dosbin sdmon
	dodoc ../readme.md
}

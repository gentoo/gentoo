# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A PDF reader in JavaScript"
HOMEPAGE="https://mozilla.github.io/pdf.js/"
SRC_URI="https://github.com/mozilla/pdf.js/releases/download/v${PV}/${P}-dist.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/pdf.js/

	doins -r build
	doins -r web
}

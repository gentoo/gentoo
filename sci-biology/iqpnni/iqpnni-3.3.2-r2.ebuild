# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Important Quartet Puzzling and NNI Operation"
HOMEPAGE="http://www.cibiv.at/software/iqpnni/"
SRC_URI="http://www.cibiv.at/software/iqpnni/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

PATCHES=(
	"${FILESDIR}"/${P}-cpp14.patch # bug #594332
)

src_install() {
	dobin src/iqpnni

	if use doc ; then
		HTML_DOCS=( manual/iqpnni-manual.html )
		dodoc manual/iqpnni-manual.pdf
	fi
	einstalldocs
}

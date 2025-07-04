# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package

DESCRIPTION="Font for Gentoo e.V. logo"
HOMEPAGE="https://gentoo-ev.org/"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="|| ( GPL-2+-with-font-exception CC-BY-SA-4.0 )"
SLOT="0"
KEYWORDS="~amd64"

SUPPLIER="public"

src_install() {
	latex-package_src_doinstall pfb afm tfm fd sty

	local f
	for f in enc map; do
		insinto "${TEXMF}/fonts/${f}/dvips/${PN}"
		doins *.${f}
	done

	insinto /etc/texmf/updmap.d
	newins - 50${PN}.cfg <<< "Map gentoonewage.map"

	dodoc README
}

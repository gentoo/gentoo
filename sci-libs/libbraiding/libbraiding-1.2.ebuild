# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Expose the functionality of cbraid as a shared library"
HOMEPAGE="https://github.com/miguelmarco/libbraiding"
SRC_URI="https://github.com/miguelmarco/${PN}/releases/download/${PV}/${P}.tar.gz"

# A few source headers still say GPLv2, but I believe that to be an
# oversight: https://github.com/jeanluct/cbraid/issues/4
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

COMMIT=b1d5212831842ee5869d99bc208a21837e4037d5

DESCRIPTION="Fast and flexible ANSI C library to read and write CSV data"
HOMEPAGE="https://github.com/rgamble/libcsv"
SRC_URI="https://github.com/rgamble/libcsv/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}

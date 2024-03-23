# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="The GAP library of Tables of Marks"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"

RDEPEND="dev-gap/atlasrep"

# The are "extra" docs and not the HTML produced by GAPDoc. The glob
# gets expanded if we use a plain variable but not if we use a bash
# array.
HTML_DOCS="htm/*"

GAP_PKG_EXTRA_INSTALL=( data )

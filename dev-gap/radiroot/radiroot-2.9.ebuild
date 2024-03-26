# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Roots of a polynomial as radicals in GAP"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"

RDEPEND="dev-gap/alnuth"

GAP_PKG_HTML_DOCDIR="htm"
gap-pkg_enable_tests

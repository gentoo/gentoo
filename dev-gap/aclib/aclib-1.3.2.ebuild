# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Almost-crystallographic group library and algorithms for GAP"
HOMEPAGE="https://www.gap-system.org/Packages/aclib.html"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-gap/polycyclic"

DOCS=( README doc/manual.pdf )

GAP_PKG_HTML_DOCDIR="htm"
gap-pkg_enable_tests

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Irreducible soluble linear groups over finite fields and more"
SLOT="0"
SRC_URI="https://github.com/bh11/${PN}/releases/download/IRREDSOL-${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="~amd64"

GAP_PKG_HTML_DOCDIR="htm"
GAP_PKG_EXTRA_INSTALL=( data fp )
gap-pkg_enable_tests

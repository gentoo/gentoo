# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP algorithms for subgroups of finite soluble groups"
SLOT="0"
SRC_URI="https://github.com/bh11/${PN}/releases/download/${P^^}/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="~amd64"

GAP_PKG_HTML_DOCDIR="htm"
gap-pkg_enable_tests

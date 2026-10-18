# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP algorithms for subgroups of finite soluble groups"
SRC_URI="https://github.com/bh11/${PN}/releases/download/CRISP-${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

GAP_PKG_HTML_DOCDIR="htm"
gap-pkg_enable_tests

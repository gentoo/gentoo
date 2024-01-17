# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="GAP transitive groups library"
SLOT="0"
SRC_URI="https://www.math.colostate.edu/~hulpke/${PN}/${PN}${PV}.tar.gz"
S="${WORKDIR}/${PN}"

# Data format is licensed Artistic-2
# Code is licensed GPL-3
LICENSE="GPL-3 Artistic-2"
KEYWORDS="~amd64"

# This is one of the four required packages whose dependencies are all
# listed explicitly.
BDEPEND="test? ( dev-gap/gapdoc )"

# Again, this is one of the four special packages that won't have gapdoc
# auto-loaded for its test suite.
PATCHES=( "${FILESDIR}/${P}-load-gapdoc-before-tests.patch" )

GAP_PKG_HTML_DOCDIR="htm"
GAP_PKG_EXTRA_INSTALL=( data )
gap-pkg_enable_tests

# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="A fast pixel-level image comparison library"
HOMEPAGE="https://pypi.org/project/pixelmatch/"
SRC_URI="https://github.com/whtsky/${PN}-py/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-py-${PV}

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_tests import-check

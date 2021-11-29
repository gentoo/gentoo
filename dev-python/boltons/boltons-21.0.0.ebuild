# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Pure-python utilities in the same spirit as the standard library"
HOMEPAGE="https://boltons.readthedocs.org/"
SRC_URI="https://github.com/mahmoud/boltons/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme

DOCS=( CHANGELOG.md README.md TODO.rst )

PATCHES=(
	"${FILESDIR}"/${P}-python3.10.patch
)

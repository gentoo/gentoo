# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="LHA archive support for Python"
HOMEPAGE="https://github.com/FrodeSolheim/python-lhafile"
SRC_URI="https://github.com/FrodeSolheim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
RESTRICT="test" # The tests don't work, they're probably outdated.

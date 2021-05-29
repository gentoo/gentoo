# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Library for building WebSocket servers and clients in Python"
HOMEPAGE="https://websockets.readthedocs.io/"
SRC_URI="https://github.com/aaugustin/${PN}/archive/${PV}.tar.gz -> ${P}-src.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc x86"

distutils_enable_tests unittest

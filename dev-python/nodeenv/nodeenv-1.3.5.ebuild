# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Node.js virtual environment builder"
HOMEPAGE="https://github.com/ekalinin/nodeenv"
SRC_URI="https://github.com/ekalinin/nodeenv/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# requires network access
RESTRICT="test"

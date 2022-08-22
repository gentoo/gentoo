# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Node.js virtual environment builder"
HOMEPAGE="https://github.com/ekalinin/nodeenv"
SRC_URI="
	https://github.com/ekalinin/nodeenv/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 x86"

# requires network access
RESTRICT="test"
PROPERTIES="test_network"

distutils_enable_tests pytest

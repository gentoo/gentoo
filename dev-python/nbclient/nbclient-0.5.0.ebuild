# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A client library for executing Jupyter notebooks"
HOMEPAGE="https://nbclient.readthedocs.io/en/latest/"
SRC_URI="https://github.com/jupyter/nbclient/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# We need to keep async_generator while we keep Python 3.6 (backport).
# If we drop 3.6, we can replace it with a sed.
# (3.5 adds the feature, 3.6 improves it with something used in this pkg)
BDEPEND="
	dev-python/async_generator[${PYTHON_USEDEP}]
	test? ( dev-python/xmltodict[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

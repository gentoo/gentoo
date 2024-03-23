# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the Linode Metadata Service"
HOMEPAGE="https://github.com/linode/py-metadata https://www.linode.com/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Tests require network, a linode account, an API key and a ssh key.
RESTRICT="test"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"

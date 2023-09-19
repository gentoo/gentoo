# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Command line client for Hound, the code search tool"
HOMEPAGE="https://beagle-hound.readthedocs.io/en/latest/
	https://github.com/beaglecli/beagle"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# setuptools is needed as rdepend, https://github.com/beaglecli/beagle/pull/14
RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/cliff-2.11.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18.4[${PYTHON_USEDEP}]
"
BDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]"

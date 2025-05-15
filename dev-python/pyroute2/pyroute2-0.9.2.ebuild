# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 pypi

DESCRIPTION="A pure Python netlink and Linux network configuration library"
HOMEPAGE="
	https://github.com/svinota/pyroute2/
	https://pypi.org/project/pyroute2/
"

LICENSE="|| ( GPL-2+ Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
# tests need root access
RESTRICT="test"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

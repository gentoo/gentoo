# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14})

inherit distutils-r1 pypi

DESCRIPTION="Language Server Protocol types code generator packages"
HOMEPAGE="
	https://github.com/microsoft/lsprotocol
	https://pypi.org/project/lsprotocol/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/cattrs[${PYTHON_USEDEP}]
"

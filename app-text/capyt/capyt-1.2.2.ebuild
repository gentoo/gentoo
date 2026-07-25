# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit pypi distutils-r1

MY_PV=$(ver_rs 2 '-')

DESCRIPTION="A python3 CLI utility to interface with cpy.pt"
HOMEPAGE="https://pypi.org/project/capyt/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/requests-2.33[${PYTHON_USEDEP}]"

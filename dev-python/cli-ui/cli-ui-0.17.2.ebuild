# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYPI_NO_NORMALIZE="1"
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Python library for better command line interfaces"
HOMEPAGE="https://your-tools.github.io/python-cli-ui/
	https://github.com/your-tools/python-cli-ui/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/your-tools/python-cli-ui.git"
else
	inherit pypi

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python library for better command line interfaces"
HOMEPAGE="
	https://your-tools.github.io/python-cli-ui/
	https://github.com/your-tools/python-cli-ui/
	https://pypi.org/project/cli-ui/
"

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
	>=dev-python/colorama-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/tabulate-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/unidecode-1.3.6[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

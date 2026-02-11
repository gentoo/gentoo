# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Python module for handling Portable Symmetric Key Container files"
HOMEPAGE="
	https://pypi.org/project/python-pskc/
	https://arthurdejong.org/python-pskc/
	https://github.com/arthurdejong/python-pskc
"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://arthurdejong.org/git/python-pskc"
else
	inherit pypi
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/signxml[${PYTHON_USEDEP}]
"

src_prepare() {
	default

	sed -i -e "s/ --cov=pskc --cov-report=term-missing:skip-covered --cov-report=html//" "${S}/setup.cfg" || die
}

distutils_enable_tests pytest

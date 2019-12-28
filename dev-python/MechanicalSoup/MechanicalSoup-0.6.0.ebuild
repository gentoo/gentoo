# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/hickford/MechanicalSoup"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A python library for automating interaction with websites"
HOMEPAGE="https://pypi.org/project/MechanicalSoup/"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/beautifulsoup-4.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
"

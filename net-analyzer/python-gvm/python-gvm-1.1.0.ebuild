# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Greenbone Vulnerability Management Python Library"
HOMEPAGE="https://www.greenbone.net/en/"
SRC_URI="https://github.com/greenbone/python-gvm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	distutils-r1_python_prepare_all
	# Exlude tests & docs to fix build issue
	sed \
		-e "s/packages=find_packages(exclude=.*/packages=find_packages(exclude=['tests*', 'docs']),/g" \
		-i "$S"/setup.py || die
}

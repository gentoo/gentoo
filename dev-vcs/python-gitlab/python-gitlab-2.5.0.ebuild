# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Python command line interface to gitlab API"
HOMEPAGE="https://github.com/python-gitlab/python-gitlab/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/python-gitlab/python-gitlab"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE="test"

BDEPEND="test? (
		dev-python/httmock[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r *.rst docs
}

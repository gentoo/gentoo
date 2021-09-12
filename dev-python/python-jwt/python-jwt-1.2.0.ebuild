# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="JSON Web Token library for python 3"
HOMEPAGE="https://github.com/GehirnInc/python-jwt"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hvac/hvac.git"
else
	SRC_URI="https://github.com/GehirnInc/python-jwt/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="test? ( dev-python/freezegun[${PYTHON_USEDEP}] )"
RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	!dev-python/pyjwt
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e 's/^addopts =.*/addopts = jwt/' setup.cfg || die
	distutils-r1_python_prepare_all
}

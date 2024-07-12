# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="A simple library to fetch data from the iTunes Store API"
HOMEPAGE="https://github.com/sleepyfran/itunespy/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sleepyfran/${PN}.git"
else
	SRC_URI="https://github.com/sleepyfran/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-python/pycountry[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

src_prepare() {
	rm setup.cfg || die

	distutils-r1_src_prepare
}

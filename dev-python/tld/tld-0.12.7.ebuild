# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Extract the top level domain (TLD) from the URL given"
HOMEPAGE="
	https://github.com/barseghyanartur/tld/
	https://pypi.org/project/tld/
"
SRC_URI="
	https://github.com/barseghyanartur/tld/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/Faker[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e '/--cov/d' pytest.ini || die
}

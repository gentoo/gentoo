# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Extract the top level domain (TLD) from the URL given"
HOMEPAGE="https://github.com/barseghyanartur/tld"
SRC_URI="https://github.com/barseghyanartur/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/Faker[${PYTHON_USEDEP}]
	)"

distutils_enable_tests --install pytest

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e '/--cov/d' pytest.ini || die
}

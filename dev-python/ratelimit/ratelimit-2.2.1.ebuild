# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="An API rate limit decorator for Python"
HOMEPAGE="https://github.com/tomasbasham/ratelimit"
SRC_URI="
	https://github.com/tomasbasham/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

src_prepare() {
	# remove --cov args injection 
	rm pytest.ini || die
	distutils-r1_src_prepare
}

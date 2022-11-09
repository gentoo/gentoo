# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Automatically build man-pages for your Python project"
HOMEPAGE="
	https://github.com/praiskup/argparse-manpage/
	https://pypi.org/project/argparse-manpage/
"
SRC_URI="
	https://github.com/praiskup/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~sparc ~x86"

BDEPEND="
	test? (
		dev-python/pip[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x COLUMNS=80
	epytest
}

# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python module import analysis tool"
HOMEPAGE="
	https://github.com/mgedmin/findimports/
	https://pypi.org/project/findimports/
"
SRC_URI="
	https://github.com/mgedmin/findimports/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_test() {
	"${EPYTHON}" testsuite.py -v || die
}

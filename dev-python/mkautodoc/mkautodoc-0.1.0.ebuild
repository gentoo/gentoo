# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Auto documentation for MkDocs"
HOMEPAGE="
	https://github.com/tomchristie/mkautodoc/
	https://pypi.org/project/mkautodoc/
"
SRC_URI="https://github.com/tomchristie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/markdown[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	PYTHONPATH="${WORKDIR}/${P}/tests/mocklib:${WORKDIR}/${P}"
	epytest
}

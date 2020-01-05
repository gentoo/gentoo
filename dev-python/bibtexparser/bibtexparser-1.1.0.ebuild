# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1 python-r1

DESCRIPTION="A BibTeX parser written in python"
HOMEPAGE="https://github.com/sciunto-org/python-bibtexparser"
SRC_URI="https://github.com/sciunto-org/python-bibtexparser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( BSD LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyparsing[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/python-${P}"

src_test() {
	python_foreach_impl nosetests
}

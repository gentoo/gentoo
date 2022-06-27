# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A BibTeX parser written in Python"
HOMEPAGE="
	https://github.com/sciunto-org/python-bibtexparser/
	https://pypi.org/project/bibtexparser/
"
SRC_URI="
	https://github.com/sciunto-org/python-bibtexparser/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/python-${P}"

LICENSE="|| ( BSD LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# fixed in upstream 5f98bac62e8ff3c8ab6b956f288f1c61b99c6a5d
	sed -e 's:unittest2:unittest:' \
		-i bibtexparser/tests/test_crossref_resolving.py || die
	# remove obsolete dep
	sed -i -e "s:'future>=0.16.0'::" setup.py || die
	distutils-r1_src_prepare
}

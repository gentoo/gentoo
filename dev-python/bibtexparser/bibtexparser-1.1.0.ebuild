# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 python-r1

DESCRIPTION="A BibTeX parser written in python"
HOMEPAGE="https://github.com/sciunto-org/python-bibtexparser"
SRC_URI="https://github.com/sciunto-org/python-bibtexparser/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/python-${P}"

LICENSE="|| ( BSD LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pyparsing[${PYTHON_USEDEP}]"

distutils_enable_tests nose

src_prepare() {
	# fixed in upstream 5f98bac62e8ff3c8ab6b956f288f1c61b99c6a5d
	sed -e 's:unittest2:unittest:' \
		-i bibtexparser/tests/test_crossref_resolving.py || die
	distutils-r1_src_prepare
}

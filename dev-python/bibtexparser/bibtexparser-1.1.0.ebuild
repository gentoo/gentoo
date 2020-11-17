# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

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

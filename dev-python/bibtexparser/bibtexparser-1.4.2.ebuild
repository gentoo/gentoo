# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

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

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/pylatexenc-2.10[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

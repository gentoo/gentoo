# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Sphinx epytext extension"
HOMEPAGE="https://pypi.org/project/sphinx-epytext/ https://github.com/jayvdb/sphinx-epytext"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc ~x86"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.7.5[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

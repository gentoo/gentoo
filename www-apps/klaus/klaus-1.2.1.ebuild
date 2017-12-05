# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A simple, easy-to-set-up Git web viewer"
HOMEPAGE="https://github.com/jonashaag/klaus/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ctags"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.13.0[${PYTHON_USEDEP}]
	dev-python/httpauth[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	ctags? (
		dev-python/python-ctags[${PYTHON_USEDEP}]
	)
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# The tests can only be run from a git repository
# so they are not included in the source distributions

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )
inherit distutils-r1

DESCRIPTION="Polyfill package for Flake8 plugins"
HOMEPAGE="https://gitlab.com/pycqa/flake8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
EGIT_REPO_URI="https://gitlab.com/pycqa/flake8-polyfill.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/flake8[${PYTHON_USEDEP}]"

# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} pypy pypy3 )
inherit distutils-r1

DESCRIPTION="Sphinx themes for Pallets and related projects"
HOMEPAGE="https://github.com/pallets/pallets-sphinx-themes"
SRC_URI="https://github.com/pallets/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"

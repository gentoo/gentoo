# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Simple test suite enabling Django app testing via setup.py"
HOMEPAGE="https://github.com/praekelt/django-setuptest"
SRC_URI="https://github.com/praekelt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/pep8[${PYTHON_USEDEP}]
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

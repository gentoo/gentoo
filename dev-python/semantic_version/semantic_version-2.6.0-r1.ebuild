# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6} pypy )

inherit distutils-r1

DESCRIPTION="Python library providing a few tools handling SemVer in Python"
HOMEPAGE="https://pypi.org/project/semantic_version/"
SRC_URI="https://github.com/rbarrois/python-semanticversion/archive/v${PV}.tar.gz -> ${P}-1.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/django[${PYTHON_USEDEP}] )"

S=${WORKDIR}/python-${P/_/}

python_test() {
	esetup.py test
}

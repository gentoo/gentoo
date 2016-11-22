# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python library used to edit or create SubRip files"
HOMEPAGE="https://github.com/byroot/pysrt https://pypi.python.org/pypi/pysrt"
# pypi tarballs don't include tests https://github.com/byroot/pysrt/issues/42
SRC_URI="https://github.com/byroot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/chardet[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[coverage(+),${PYTHON_USEDEP}]
		${RDEPEND}
	)
"

python_test() {
	nosetests --with-coverage --cover-package=pysrt \
		|| die "Tests failed under ${EPYTHON}"
}

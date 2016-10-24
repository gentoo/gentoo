# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit python-r1

DESCRIPTION="Library to parse and apply unified diffs"
HOMEPAGE="https://github.com/techtonik/python-patch/"
SRC_URI="https://github.com/techtonik/python-patch/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/python-${P}"

src_test() {
	python_foreach_impl tests/run_tests.py
}

src_install() {
	default
	python_foreach_impl python_doexe patch.py
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A powerful and robust templating system for Python"
HOMEPAGE="http://www.alcyone.com/software/empy/"
SRC_URI="http://www.alcyone.com/software/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc x86"
IUSE="doc"

python_test() {
	"${PYTHON}" em.py sample.em | diff sample.bench -
	assert "Testing failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		docinto examples
		dodoc sample.em sample.bench
		# 3.3 has the html in this funny place. Fix in later version:
		docinto html
		dodoc doc/home/max/projects/empy/doc/em/*
		dodoc doc/home/max/projects/empy/doc/em.html
		dodoc doc/index.html
	fi
}

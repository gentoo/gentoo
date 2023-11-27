# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Python interface to Frank Lübeck's Conway polynomial database"
HOMEPAGE="https://pypi.org/project/conway-polynomials/
	https://github.com/sagemath/conway-polynomials"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

python_test(){
	PYTHONPATH="src" \
		  "${EPYTHON}" -m doctest src/conway_polynomials/__init__.py \
		  || die
}

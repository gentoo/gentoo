# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="A usable configuration management system"
HOMEPAGE="https://www.cdi.st/ https://code.ungleich.ch/ungleich-public/cdist"
SRC_URI="https://code.ungleich.ch/ungleich-public/cdist/-/archive/${PV}/cdist-${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_sphinx docs/src dev-python/sphinx_rtd_theme
distutils_enable_tests unittest

# only required for py3.6 compatibility
PATCHES=( "${FILESDIR}"/${P}-tests.patch )

python_prepare_all() {
	echo "VERSION='${PV}'" > cdist/version.py || die

	distutils-r1_python_prepare_all
}

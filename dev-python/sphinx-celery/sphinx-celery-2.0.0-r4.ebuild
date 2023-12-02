# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Celery Sphinx Theme and Utilities"
HOMEPAGE="
	https://github.com/celery/sphinx_celery/
	https://pypi.org/project/sphinx-celery/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/sphinx-2.0.0[${PYTHON_USEDEP}]
"

# https://bugs.gentoo.org/show_bug.cgi?id=911637
PATCHES=( "${FILESDIR}/${P}-extlinks.patch" )

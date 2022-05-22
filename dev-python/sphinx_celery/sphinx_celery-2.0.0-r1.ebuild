# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Celery Sphinx Theme and Utilities"
HOMEPAGE="https://pypi.org/project/sphinx_celery/ https://github.com/celery/sphinx_celery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND=">=dev-python/sphinx-2.0.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

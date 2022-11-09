# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Cross-platform cross-python shutil.which functionality"
HOMEPAGE="https://github.com/cookiecutter/whichcraft"
SRC_URI="https://github.com/cookiecutter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

DOCS=( README.rst HISTORY.rst CONTRIBUTING.rst )

distutils_enable_tests pytest

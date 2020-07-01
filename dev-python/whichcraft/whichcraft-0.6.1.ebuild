# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Cross-platform cross-python shutil.which functionality"
HOMEPAGE="https://github.com/pydanny/whichcraft"
SRC_URI="https://github.com/pydanny/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

DOCS=( README.rst HISTORY.rst CONTRIBUTING.rst )

distutils_enable_tests pytest

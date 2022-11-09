# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Auto-generate PEP-484 annotations"
HOMEPAGE="https://github.com/dropbox/pyannotate"
SRC_URI="https://github.com/dropbox/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/mypy_extensions[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

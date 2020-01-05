# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Multithreaded Click apps made easy."
HOMEPAGE="https://github.com/click-contrib/click-threading https://pypi.org/project/click-threading/"
SRC_URI="https://github.com/click-contrib/${PN}/archive/${PV}.tar.gz -> ${P}-gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND=">=dev-python/click-5.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

DOCS=( README.rst )

distutils_enable_tests pytest

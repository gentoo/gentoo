# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Module for decorators, wrappers and monkey patching"
HOMEPAGE="https://github.com/GrahamDumpleton/wrapt"
SRC_URI="https://github.com/GrahamDumpleton/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

PATCHES=(
	"${FILESDIR}"/${P}-py39.patch
)

python_compile() {
	local WRAPT_EXTENSIONS=true

	distutils-r1_python_compile
}

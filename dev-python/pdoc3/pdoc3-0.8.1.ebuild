# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Auto-generate API documentation for Python projects"
HOMEPAGE="https://pdoc3.github.io/pdoc/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/mako
	>=dev-python/markdown-3.0
"
DEPEND="
	${RDEPEND}
	dev-python/wheel
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i \
		-e "/setuptools_git/d" \
		-e "/setuptools_scm/d" \
		setup.py || die
}

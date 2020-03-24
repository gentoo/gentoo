# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
#DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Bash style brace expansion for Python"
HOMEPAGE="
	https://github.com/facelessuser/bracex
	https://pypi.org/project/bracex
"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND="
	${RDEPEND}
	doc? (
		dev-python/mkdocs-git-revision-date-localized-plugin[${PYTHON_USEDEP}]
		dev-python/mkdocs_pymdownx_material_extras[${PYTHON_USEDEP}]
		dev-python/pyspelling[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile_all() {
	use doc && mkdocs build || die
	default
}

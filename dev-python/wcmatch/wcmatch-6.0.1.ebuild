# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
#DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Wildcard/glob file name matcher"
HOMEPAGE="
	https://github.com/facelessuser/wcmatch
	https://pypi.org/project/wcmatch"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/backrefs-4.1[${PYTHON_USEDEP}]
	>=dev-python/bracex-2.0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/bracex[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest
distutils_enable_sphinx docs/src \
				dev-python/mkdocs-git-revision-date-localized-plugin \
				dev-python/mkdocs_pymdownx_material_extras \
				dev-python/pyspelling

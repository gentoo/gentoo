# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
#DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MYPV="${PV/_beta/b}"

DESCRIPTION="Custom alterations based on Mkdocs-Material"
HOMEPAGE="
	https://github.com/facelessuser/mkdocs_pymdownx_material_extras
	https://pypi.org/project/mkdocs-pymdownx-material-extras"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${MYPV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/mkdocs-material[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-7.0_beta2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

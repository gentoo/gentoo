# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Custom alterations based on Mkdocs-Material"
HOMEPAGE="
	https://github.com/facelessuser/mkdocs_pymdownx_material_extras
	https://pypi.org/project/mkdocs-pymdownx-material-extras"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/mkdocs-material-5.0.2[${PYTHON_USEDEP}]
"

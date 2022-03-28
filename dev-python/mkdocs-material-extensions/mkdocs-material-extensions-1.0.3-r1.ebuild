# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Extension pack for Python Markdown"
HOMEPAGE="
	https://github.com/facelessuser/mkdocs-material-extensions
	https://pypi.org/project/mkdocs-material-extensions
"
SRC_URI="https://github.com/facelessuser/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="test"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND=">=dev-python/mkdocs-material-5.0.0[${PYTHON_USEDEP}]"

BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

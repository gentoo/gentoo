# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=github-links-${PV}
DESCRIPTION="An extension which adds links to GitHub users, repositories, issues and commits"
HOMEPAGE="
	https://github.com/Python-Markdown/github-links/
	https://pypi.org/project/mdx-gh-links/
"
SRC_URI="
	https://github.com/Python-Markdown/github-links/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/markdown-3.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

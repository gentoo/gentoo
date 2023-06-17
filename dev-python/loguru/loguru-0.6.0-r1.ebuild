# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python logging made (stupidly) simple"
HOMEPAGE="
	https://github.com/Delgan/loguru/
	https://pypi.org/project/loguru/
"
SRC_URI="
	https://github.com/Delgan/loguru/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/Delgan/loguru/commit/4fe21f66991abeb1905e24c3bc3c634543d959a2.patch
		-> ${P}-py311-repr-tests.patch
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

BDEPEND="
	test? (
		>=dev-python/colorama-0.3.4[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PV}-typos.patch"
	"${FILESDIR}/${PV}-py311-fix.patch"
	"${DISTDIR}/${P}-py311-repr-tests.patch"
)

# filesystem buffering tests may fail
# on tmpfs with 64k PAGESZ, but pass fine on ext4
distutils_enable_tests pytest

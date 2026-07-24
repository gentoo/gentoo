# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pygments Github custom lexers"
HOMEPAGE="
	https://github.com/liluo/pygments-github-lexers/
	https://pypi.org/project/pygments-github-lexers/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/pygments-github-lexers-0.0.5-escape-sequences.patch"
)

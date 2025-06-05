# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python binding for MeCab"
HOMEPAGE="
	https://taku910.github.io/mecab/
	https://github.com/taku910/mecab/
	https://pypi.org/project/mecab-python3/
"
SRC_URI="https://github.com/SamuraiT/mecab-python3/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}3-${PV}

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

DEPEND=">=app-text/mecab-0.996"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

distutils_enable_tests pytest

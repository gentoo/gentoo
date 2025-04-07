# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python supercharged for the fastai library"
HOMEPAGE="https://fastcore.fast.ai/"
SRC_URI="https://github.com/AnswerDotAI/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # No test available

RDEPEND="dev-python/packaging[${PYTHON_USEDEP}]"

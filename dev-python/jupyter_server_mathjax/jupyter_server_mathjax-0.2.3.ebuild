# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="MathJax resources as a Jupyter Server Extension"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/jupyter_packaging[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-tornasync[${PYTHON_USEDEP}]
	)
"
RDEPEND="dev-python/jupyter_server[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	# Don't try (and fail) to fetch things from the internet with npm
	# https://bugs.gentoo.org/820317
	sed -i -e '/install_npm(here)/d' setup.py || die

	distutils-r1_python_prepare_all
}

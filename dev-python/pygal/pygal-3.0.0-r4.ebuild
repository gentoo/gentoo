# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 optfeature

DESCRIPTION="A python SVG charts generator"
HOMEPAGE="https://github.com/Kozea/pygal/"
SRC_URI="https://github.com/Kozea/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pyquery[${PYTHON_USEDEP}]
		media-gfx/cairosvg[${PYTHON_USEDEP}]
	)
"

# CHANGELOG is a symlink to docs/changelog.rst
DOCS=( docs/changelog.rst README.md )

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# Not actually required unless we want to do setup.py test
	# https://github.com/Kozea/pygal/issues/430
	sed -i -e "/setup_requires/d" setup.py || die
	distutils-r1_python_prepare_all
}

pkg_postinst() {
	optfeature "improving rendering speed" "dev-python/lxml"
	optfeature "png rendering" "dev-python/cairosvg"
}

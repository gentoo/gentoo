# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1 optfeature

DESCRIPTION="Validate configuration and produce human readable error messages"
HOMEPAGE="https://github.com/willmcgugan/rich"
SRC_URI="https://github.com/willmcgugan/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/commonmark[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature "integration with HTML widgets for Jupyter" dev-python/ipywidgets
}

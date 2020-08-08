# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 eutils

DESCRIPTION="tool to manage multiple virtualenvs written in pure python"
HOMEPAGE="
	https://github.com/berdario/pew
	https://pypi.org/project/pew/"
SRC_URI="https://github.com/berdario/pew/archive/1.2.0.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# see https://github.com/berdario/pew/issues/219
RDEPEND="
	<dev-python/virtualenv-20[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-clone-0.2.5[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing

	pytest -vv || die "Testsuite failed under ${EPYTHON}"
}

pkg_postinst() {
	elog "Optional dependencies:"
	optfeature "pythonz support" dev-python/pythonz-bd
}

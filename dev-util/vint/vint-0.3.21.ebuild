# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Lint tool for Vim script language"
HOMEPAGE="https://github.com/Kuniwak/vint https://pypi.org/project/vim-vint/"
SRC_URI="https://github.com/Kuniwak/vint/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/ansicolor-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	# Tests fail due to python 3.8 warnings in stderr that appear when
	# compiled byte code is disabled
	# https://github.com/Vimjas/vint/issues/355
	[[ "${EPYTHON}" == python3.8 ]] && return
	pytest -vv || die "Tests fail with ${EPYTHON}"
}

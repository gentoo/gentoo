# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Terminals served to term.js using Tornado websockets"
HOMEPAGE="https://pypi.org/project/terminado/ https://github.com/jupyter/terminado"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="amd64 ~arm ~arm64 hppa ~ia64 ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/ptyprocess[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_test() {
	# workaround new readline defaults
	echo "set enable-bracketed-paste off" > "${T}"/inputrc || die
	local -x INPUTRC="${T}"/inputrc
	distutils-r1_src_test
}

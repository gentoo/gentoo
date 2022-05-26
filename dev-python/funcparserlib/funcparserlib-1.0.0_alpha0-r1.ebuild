# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PV="${PV/_alpha/a}"

DESCRIPTION="Recursive descent parsing library based on functional combinators"
HOMEPAGE="https://pypi.org/project/funcparserlib/"
SRC_URI="
	https://github.com/vlasovskikh/funcparserlib/archive/${MY_PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

BDEPEND="test? ( dev-python/six[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

src_prepare() {
	sed -e '/requires/s:poetry:&-core:' \
		-e '/backend/s:poetry:&.core:' \
		-i pyproject.toml || die

	distutils-r1_src_prepare
}

python_install_all() {
	local DOCS=( doc/*.md )
	distutils-r1_python_install_all
}

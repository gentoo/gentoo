# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

BDEPEND="test? ( dev-python/six[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

python_install_all() {
	local DOCS=( doc/*.md )
	distutils-r1_python_install_all
}

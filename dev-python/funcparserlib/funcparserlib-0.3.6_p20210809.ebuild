# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

COMMIT="d4ba3955ffc10544dbae6aaed68bcab21d0c294b"

DESCRIPTION="Recursive descent parsing library based on functional combinators"
HOMEPAGE="https://pypi.org/project/funcparserlib/"
SRC_URI="
	https://github.com/vlasovskikh/funcparserlib/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

BDEPEND="test? ( dev-python/six[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

python_install_all() {
	local DOCS=( doc/*.md )
	distutils-r1_python_install_all
}

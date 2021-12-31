# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Service identity verification for pyOpenSSL"
HOMEPAGE="https://github.com/pyca/service-identity"
SRC_URI="https://github.com/pyca/service-identity/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/${P/_/-}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

# TODO: upstream made pyopenssl optional
RDEPEND="
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( $(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]') )"

distutils_enable_tests pytest

python_check_deps() {
	use doc || return 0

	has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

python_prepare_all() {
	# Prevent un-needed download during build
	sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/_build/html/. )
	fi
}

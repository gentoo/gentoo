# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/boto3/boto3-1.1.1.ebuild,v 1.1 2015/07/29 18:53:19 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="The AWS SDK for Python"
HOMEPAGE="https://github.com/boto/boto3"
SRC_URI="https://github.com/boto/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

CDEPEND="
	>=dev-python/botocore-1.1.0[${PYTHON_USEDEP}]
	<dev-python/botocore-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/jmespath-0.6.2[${PYTHON_USEDEP}]
	<dev-python/jmespath-1.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '=dev-python/futures-2.2.0[${PYTHON_USEDEP}]' 'python2_7')
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/guzzle_sphinx_theme-0.7.10[${PYTHON_USEDEP}]
		<dev-python/guzzle_sphinx_theme-0.8[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.3[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
	)
	test? (
		${CDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests tests/unit/ tests/functional/ || die "test failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="The AWS SDK for Python"
HOMEPAGE="https://github.com/boto/boto3"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc test"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/boto/boto3"
	inherit git-r3
else
	SRC_URI="https://github.com/boto/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
fi

RDEPEND="
	>=dev-python/botocore-1.8.20[${PYTHON_USEDEP}]
	>=dev-python/jmespath-0.7.1[${PYTHON_USEDEP}]
	<dev-python/jmespath-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/s3transfer-0.1.10[${PYTHON_USEDEP}]
	<dev-python/s3transfer-0.2.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/guzzle_sphinx_theme-0.7.10[${PYTHON_USEDEP}]
		<dev-python/guzzle_sphinx_theme-0.8[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.3[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.7[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests -v tests/unit/ tests/functional/ || die "test failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}

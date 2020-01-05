# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Mock out responses from the requests package"
HOMEPAGE="https://github.com/jamielennox/requests-mock"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/subunit[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/requests-1.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# Disable intersphinx
	# Disable reno which only works inside a git repository
	sed -i -e "s/'reno.sphinxext',//" \
		-e "s/'sphinx.ext.intersphinx'//" \
		doc/source/conf.py || die
	# Remove the release notes section which requires reno
	rm doc/source/release-notes.rst || die
	sed -i '/^=============$/,/release-notes/d' doc/source/index.rst || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build doc/source docs/source/build/_html || die
		HTML_DOCS=( docs/source/build/_html/. )
	fi
}

python_test() {
	rm -rf .testrepository \
		|| die "couldn't remove '.testrepository' under ${EPYTHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}

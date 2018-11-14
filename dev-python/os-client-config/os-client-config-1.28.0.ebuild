# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="OpenStack Client Configuation Library"
HOMEPAGE="http://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc test"

CDEPEND=">=dev-python/pbr-1.8.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
		dev-python/extras[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.144[${PYTHON_USEDEP}]
		>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
		!~dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
		<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-1.2[${PYTHON_USEDEP}]
		>=dev-python/python-glanceclient-0.18.0[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/reno-0.1.1[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
		!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/sphinx-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/openstackdocstheme-1.5.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/requestsexceptions-1.1.1[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/test_get_all_clouds.patch
)

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	distutils_install_for_testing

	rm -rf .testrepository || die "couldn't remove '.testrepository' under ${EPTYHON}"

	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all
}

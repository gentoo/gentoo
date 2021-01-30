# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python test doubles"
HOMEPAGE="https://bitbucket.org/DavidVilla/python-doublex"
SRC_URI="https://bitbucket.org/DavidVilla/python-${PN}/get/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="doc test"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/pyhamcrest[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"
RDEPEND="${CDEPEND}"

distutils_enable_tests setup.py

python_prepare_all() {
	# Disable broken tests
	# https://bitbucket.org/DavidVilla/python-doublex/issues/5/support-for-python-36-37-38-tests-failing
	sed -i "s/test_*hamcrest_/_&/" doublex/test/report_tests.py || die
	# https://bitbucket.org/DavidVilla/python-doublex/issues/6/more-failing-tests-with-python-39
	sed -i -r "s/test_(proxyspy_get_stubbed_property|stub_property|custom_equality_comparable_objects)/_&/" \
		doublex/test/unit_tests.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all

	rm "${ED}"/usr/README.rst || die "Couldn't remove spurious README.rst"
}

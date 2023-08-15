# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )

inherit distutils-r1

DESCRIPTION="A daemon to automatically suspend and wake up a system"
HOMEPAGE="
	https://github.com/languitar/autosuspend
	https://autosuspend.readthedocs.io
"
SRC_URI="
	https://github.com/languitar/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus mpd test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/portalocker[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	mpd? ( dev-python/python-mpd2[${PYTHON_USEDEP}] )
"

BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/icalendar[${PYTHON_USEDEP}]
		dev-python/jsonpath-ng[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/pytest-datadir[${PYTHON_USEDEP}]
		dev-python/pytest-httpserver[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/python-dbusmock[${PYTHON_USEDEP}]
		dev-python/python-mpd2[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/tzlocal[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	tests/test_checks_util.py::TestNetworkMixin::test_file_url
)

distutils_enable_tests pytest
distutils_enable_sphinx doc/source \
						dev-python/furo \
						dev-python/recommonmark \
						dev-python/sphinx-autodoc-typehints \
						dev-python/sphinx-issues \
						dev-python/sphinxcontrib-plantuml

python_test() {
	# Disable code coverage in tests by setting addopts to the empty value.
	epytest -o addopts=
}

src_install() {
	distutils-r1_src_install
	mv "${ED}/usr/etc" "${ED}/etc" || die
}

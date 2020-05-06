# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Low-level components of distutils2/packaging"
HOMEPAGE="https://pypi.org/project/distlib/
	https://bitbucket.org/pypa/distlib/"
# pypi has zip only :-(
SRC_URI="
	https://bitbucket.org/pypa/distlib/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

distutils_enable_tests setup.py

src_prepare() {
	# this test assumes pristine venv with no system packages
	sed -e 's:test_dependency_finder:_&:' \
		-i tests/test_locators.py || die
	# no clue but it looks horribly fragile
	sed -e 's:test_sequencer_basic:_&:' \
		-i tests/test_util.py || die
	# TODO: investigate
	sed -e 's:test_upload:_&:' \
		-i tests/test_index.py || die
	# these require Internet
	sed -e 's:test_search:_&:' \
		-i tests/test_index.py || die
	sed -e 's:test_aggregation:_&:' \
		-e 's:test_all:_&:' \
		-e 's:test_dist_reqts:_&:' \
		-e 's:test_json:_&:' \
		-e 's:test_prereleases:_&:' \
		-e 's:test_scraper:_&:' \
		-i tests/test_locators.py || die
	sed -e 's:test_package_data:_&:' \
		-i tests/test_util.py || die
	# doesn't work with our patched pip
	sed -e '/PIP_AVAIL/s:True:False:' \
		-i tests/test_wheel.py || die

	distutils-r1_src_prepare
}

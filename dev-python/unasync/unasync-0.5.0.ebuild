# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="The async transformation code."
HOMEPAGE="https://github.com/python-trio/unasync"
SRC_URI="https://github.com/python-trio/unasync/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	# Stop test from breaking itself
	sed -i 's/\(env\["PYTHONPATH"\] = os.path.realpath(os.path.join(TEST_DIR, ".."))\)/#\1/' "${S}/tests/test_unasync.py" || die
	default_src_prepare
}

distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme
distutils_enable_tests --install pytest

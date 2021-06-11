# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Low-level components of distutils2/packaging"
HOMEPAGE="https://pypi.org/project/distlib/
	https://bitbucket.org/pypa/distlib/"
# pypi has zip only :-(
SRC_URI="
	https://bitbucket.org/pypa/distlib/get/${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="test"
# This package's tests are extremely fragile and tend to break or hang
# when it doesn't like metadata of packages installed on the system.
RESTRICT="test"

# pypiserver is called as external executable
# openpyxl installs invalid metadata that breaks distlib
BDEPEND="
	test? (
		dev-python/pypiserver
		!!<dev-python/openpyxl-3.0.3[${PYTHON_USEDEP}]
	)"

src_prepare() {
	# make sure they're not used
	rm -r tests/unittest2 || die
	rm tests/pypi-server-standalone.py || die

	# use system pypiserver instead of broken bundled one
	eapply "${FILESDIR}"/distlib-0.3.1-system-pypiserver.py || die

	# doesn't work with our patched pip
	sed -e '/PIP_AVAIL/s:True:False:' \
		-i tests/test_wheel.py || die

	distutils-r1_src_prepare
}

python_test() {
	local -x SKIP_ONLINE=1
	local -x PYTHONHASHSEED=0
	"${EPYTHON}" tests/test_all.py -v ||
		die "Tests failed with ${EPYTHON}"
}

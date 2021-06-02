# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A user space multicast named pipe implementation backed by a regular file"
HOMEPAGE="https://github.com/zmedico/filebus"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+inotify test"
RESTRICT="!test? ( test )"
RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/filelock[${PYTHON_USEDEP}]
	inotify? ( dev-python/watchdog[${PYTHON_USEDEP}] )"
BDEPEND="${RDEPEND}"

python_test() {
	python test/test_filebus.py || die "tests failed for ${EPYTHON}"
}

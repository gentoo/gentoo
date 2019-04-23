# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
inherit distutils-r1

DESCRIPTION="Pythonic task execution"
HOMEPAGE="https://pypi.org/project/invoke/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock
		>=dev-python/pytest-3.0
		>=dev-python/pytest-relaxed-1.1.4
	)"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-skip-pty-tests.patch"
)

python_test() {
	# -s flag is important: tests fail when pytest isn't in "no capture" mode
	# -p pytest_relaxed: this plugin has to be loaded explicitly
	pytest -s -v -p pytest_relaxed.plugin || die "Tests failed"
}

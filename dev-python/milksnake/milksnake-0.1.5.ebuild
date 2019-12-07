# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7})
inherit distutils-r1

DESCRIPTION="A setuptools/wheel/cffi extension to embed a binary data in wheels"
HOMEPAGE="https://github.com/getsentry/milksnake"
SRC_URI="https://github.com/getsentry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		virtual/rust
	)
"
DEPEND="
	>=dev-python/cffi-1.6.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_test() {
	py.test -v || die "Tests failed"
}

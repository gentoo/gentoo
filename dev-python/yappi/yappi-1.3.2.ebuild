# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

# no tags on github, no tests on pypi
COMMIT_HASH="c256f28d3ccc2bc1692a5a090dc8f774c4933c16"

DESCRIPTION="Yet Another Python Profiler"
HOMEPAGE="https://pypi.org/project/yappi/ https://github.com/sumerc/yappi"
SRC_URI="https://github.com/sumerc/yappi/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-python/gevent[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

PATCHES=(
	"${FILESDIR}/yappi-1.2.5-warnings.patch"
	"${FILESDIR}/yappi-1.3.0-tests.patch"
)

python_prepare_all() {
	cp tests/utils.py "${S}" || die
	distutils-r1_python_prepare_all
}

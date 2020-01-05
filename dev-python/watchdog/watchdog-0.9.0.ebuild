# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7})

inherit distutils-r1 eutils

DESCRIPTION="Python API and shell utilities to monitor file system events"
HOMEPAGE="https://github.com/gorakhargosh/watchdog"
SRC_URI="https://github.com/gorakhargosh/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="test"

CDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/pathtools[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? ( >=dev-python/pytest-timeout-0.3[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	default
	rm tox.ini || die
}

pkg_postinst() {
	optfeature "Bash completion" dev-python/argcomplete
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Test Daemon"
HOMEPAGE="https://github.com/brunobord/tdaemon"
SRC_URI="https://github.com/tampakrap/tdaemon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="coverage"
LICENSE="MIT"
SLOT="0"

RDEPEND="dev-python/notify-python[${PYTHON_USEDEP}]
	coverage? ( dev-python/coverage[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	if "${PYTHON}" -m test; then
		einfo "Test passed under ${EPYTHON}"
	else
		die "Test failed under ${EPYTHON}"
	fi
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/keyring/keyring-3.1.ebuild,v 1.4 2015/04/08 08:04:55 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 pypy )
#tests restricted due to unpackaged dependancies
RESTRICT="test"

inherit distutils-r1
DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="https://bitbucket.org/kang/python-keyring-lib"
SRC_URI="mirror://pypi/k/${PN}/${P}.zip"

LICENSE="PSF-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		app-arch/unzip"
RDEPEND=""

PATCHES=(
)
#	"${FILESDIR}/setup-1.0.patch"

python_test() {
	# test_backend.py and test_core.py access keyring backends
	# which may spawn password prompts and do other damage.

	# XXX: leave out the harmless tests (dummy backends?)

	for t in test_{cli,util}.py; do
		"${PYTHON}" "${BUILD_DIR}"/lib/${PN}/tests/${t} \
			|| die "${t} fails with ${EPYTHON}"
	done
}

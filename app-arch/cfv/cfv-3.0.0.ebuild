# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# Tests fail with pypy3 as of PyPy 7.3.9 / Python 3.9.12
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 optfeature

DESCRIPTION="Command-line File Verify - versatile file checksum creator and verifier"
HOMEPAGE="https://github.com/cfv-project/cfv/"
# Tests aren't included in PyPI tarballs
SRC_URI="https://github.com/cfv-project/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-arch/cksfv
	)
"

python_prepare_all() {
	# Remove upstream's attempt to install the man page
	sed -i '/\sdata_files=/d' setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# In order to run integration tests in addition to unit tests, we can't
	# just rely on pytest here, we need to use upstream's runner.
	"${EPYTHON}" "test/test.py" || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	doman cfv.1
}

pkg_postinst() {
	optfeature "the dimension column of JPEG Sheriff crc files" dev-python/pillow
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mamba/mamba-0.8.ebuild,v 1.1 2014/10/18 14:58:21 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 )

inherit distutils-r1

DESCRIPTION="The definitive testing tool for Python. Born under the banner of Behavior Driven Development"
HOMEPAGE="http://nestorsalceda.github.io/mamba"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		~dev-python/expects-0.2.1[${PYTHON_USEDEP}]
		~dev-python/doublex-1.8.1[${PYTHON_USEDEP}]
		>=dev-python/pyhamcrest-1.8.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	~dev-python/clint-0.3.1[${PYTHON_USEDEP}]
	~dev-python/coverage-3.7[${PYTHON_USEDEP}]
	>=dev-python/watchdog-0.6.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	ebegin 'patching requirements.txt'
	sed \
		-e '3s/==/>=/' \
		-i requirements.txt
	STATUS=$?
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	distutils-r1_python_prepare_all
}

python_test() {
	local DISTUTILS_NO_PARALLEL_BUILD=TRUE

	rm -f "${HOME}"/.pydistutils.cfg || die "Couldn't remove pydistutils.cfg"

	distutils_install_for_testing

	"${TEST_DIR}"/scripts/mamba || die "Tests failed under ${EPYTHON}"
}

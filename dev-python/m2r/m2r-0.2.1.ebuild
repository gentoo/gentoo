# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Markdown to reStructuredText converter"
HOMEPAGE="https://github.com/miyakogi/m2r https://pypi.org/project/m2r/"
SRC_URI="https://github.com/miyakogi/m2r/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 s390 sparc x86"
IUSE="test"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	<dev-python/mistune-2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pygments[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )
	${RDEPEND}
"

PATCHES=(
	# pulled from upstream git
	"${FILESDIR}/m2r-0.2.1-upstream-fix.patch"
	"${FILESDIR}/m2r-0.2.1-tests.patch"
	# skip tests that need internet
	"${FILESDIR}/m2r-0.2.1-tests-network.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# fix a Q/A violation, trying to install the tests as an independant package
	sed -e "s/packages=\['tests'\],/packages=[],/" -i setup.py
	# add missing test files
	cp "${FILESDIR}/"test.md tests/ || die
	cp "${FILESDIR}/"test.rst tests/ || die
	cp "${FILESDIR}/"m2r.1 "${S}" || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	doman m2r.1
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1 eutils

DESCRIPTION="Useful miscellaneous modules used by Logilab projects"
HOMEPAGE="http://www.logilab.org/project/logilab-common http://pypi.python.org/pypi/logilab-common"
SRC_URI="ftp://ftp.logilab.org/pub/common/${P}.tar.gz mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test doc"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# egenix-mx-base tests are optional and supports python2 only.
DEPEND="${RDEPEND}
	dev-python/six[${PYTHON_USEDEP}]
	test? (	$(python_gen_cond_dep 'dev-python/egenix-mx-base[${PYTHON_USEDEP}]' python2_7)
		dev-python/pytz[${PYTHON_USEDEP}] )
	doc? ( $(python_gen_cond_dep 'dev-python/epydoc[${PYTHON_USEDEP}]' python2_7) )"

PATCHES=(
	# Make sure setuptools does not create a zip file in python_test;
	# this is buggy and causes tests to fail.
	"${FILESDIR}/${PN}-0.59.1-zipsafe.patch"
)
# Req'd for impl specific failures in the testsuite
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	sed -e 's:(CURDIR):{S}/${P}:' -i doc/makefile || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		# Based on the doc build in Arfrever's ebuild. It works
		pushd doc > /dev/null
		mkdir -p apidoc || die
		epydoc --parse-only -o apidoc --html -v --no-private --exclude=__pkginfo__ --exclude=setup --exclude=test \
			-n "Logilab's common library" "$(ls -d ../build/lib/logilab/common/)" build \
			|| die "Generation of documentation failed"
	fi
}

python_test() {
	distutils_install_for_testing

	# https://www.logilab.org/ticket/149345
	# Prevent timezone related failure.
	export TZ=UTC

	# Make sure that the tests use correct modules.
	pushd "${TEST_DIR}"/lib > /dev/null || die
	"${TEST_DIR}"/scripts/pytest || die "Tests fail with ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	distutils-r1_python_install_all

	doman doc/pytest.1
	use doc &&  dohtml -r doc/apidoc/.
}

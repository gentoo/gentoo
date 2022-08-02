# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Pure-Python implementation of the Git file formats and protocols"
HOMEPAGE="
	https://github.com/jelmer/dulwich/
	https://pypi.org/project/dulwich/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+ Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~ia64 ppc ~ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		!hppa? ( !ia64? ( !s390? (
			dev-python/gevent[${PYTHON_USEDEP}]
			dev-python/geventhttpclient[${PYTHON_USEDEP}]
		) ) )
		app-crypt/gpgme[python,${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/fastimport[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs

python_test() {
	# remove interference from the tests that do stuff like user.name
	unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_AUTHOR_DATE \
		GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL GIT_COMMITTER_DATE EMAIL
	# Do not use make check which rebuilds the extension and uses -Werror,
	# causing unexpected failures.
	"${EPYTHON}" -m unittest -v dulwich.tests.test_suite ||
		die "tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}

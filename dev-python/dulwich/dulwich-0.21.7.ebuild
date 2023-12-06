# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python implementation of the Git file formats and protocols"
HOMEPAGE="
	https://github.com/jelmer/dulwich/
	https://pypi.org/project/dulwich/
"

LICENSE="GPL-2+ Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/urllib3-1.25[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		app-crypt/gpgme[python,${PYTHON_USEDEP}]
		dev-python/fastimport[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs

python_test() {
	# remove interference from the tests that do stuff like user.name
	unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_AUTHOR_DATE
	unset GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL GIT_COMMITTER_DATE
	unset EMAIL
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

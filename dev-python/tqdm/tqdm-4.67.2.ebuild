# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/tqdm/tqdm
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit bash-completion-r1 distutils-r1 pypi

DESCRIPTION="Add a progress meter to your loops in a second"
HOMEPAGE="
	https://github.com/tqdm/tqdm/
	https://pypi.org/project/tqdm/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="examples"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-{asyncio,timeout} )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# Skip unpredictable performance tests
	tests/tests_perf.py
)

python_install_all() {
	doman tqdm/tqdm.1
	newbashcomp tqdm/completion.sh tqdm
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="C parser and AST generator written in Python"
HOMEPAGE="
	https://github.com/eliben/pycparser/
	https://pypi.org/project/pycparser/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-python/ply:=[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

distutils_enable_tests unittest

python_prepare_all() {
	local PATCHES=(
		# https://github.com/eliben/pycparser/pull/494
		"${FILESDIR}"/${P}-lextab-cache.patch
	)

	# remove the original files to guarantee their regen
	rm pycparser/{c_ast,lextab,yacctab}.py || die

	# kill sys.path manipulations to force the tests to use built files
	sed -i -e '/sys\.path/d' tests/*.py || die

	# Ensure we can find tests in our directory
	sed -i -e 's/from tests.test_util/from test_util/g' tests/test_*.py || die

	ln -s "${S}"/examples tests/examples || die

	rm tests/test_examples.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# Skip tests if cpp is not in PATH
	type -P cpp >/dev/null || return 0
	# change workdir to avoid '.' import
	cd tests || die

	# Ensure that 'cpp' is called with the right arguments
	# Tests don't seem to always pass the include they intend to use.
	mkdir -p "${T}"/bin || die
	cat > "${T}"/bin/cpp <<-EOF || die
	#!${BROOT}/bin/bash
	exec ${BROOT}/usr/bin/cpp -I${S}/utils/fake_libc_include/ \$@
	EOF
	chmod +x "${T}"/bin/cpp || die

	PATH="${T}/bin:${PATH}" eunittest
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

DESCRIPTION="C parser and AST generator written in Python"
HOMEPAGE="https://github.com/eliben/pycparser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="dev-python/ply:=[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
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

python_compile() {
	distutils-r1_python_compile

	# note: tables built by py3.5+ are incompatible with older versions
	# because of 100 group limit of 're' module -- just generate them
	# separately optimized for each target instead
	pushd "${BUILD_DIR}"/lib/pycparser > /dev/null || die
	"${PYTHON}" _build_tables.py || die
	popd > /dev/null || die
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

python_install() {
	distutils-r1_python_install

	# setup.py generates {c_ast,lextab,yacctab}.py with bytecode disabled.
	python_optimize
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="YAML parser and emitter for Python"
HOMEPAGE="
	https://pyyaml.org/wiki/PyYAML
	https://pypi.org/project/PyYAML/
	https://github.com/yaml/pyyaml/"
SRC_URI="https://github.com/yaml/pyyaml/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="examples"

RDEPEND="dev-libs/libyaml:="
DEPEND="${RDEPEND}"
# bundled distutils is broken w/ pypy3 in setuptools < 58
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/setuptools-58.2.0[${PYTHON_USEDEP}]
	' pypy3)
"

distutils_enable_tests setup.py

src_configure() {
	export PYYAML_FORCE_CYTHON=1
	DISTUTILS_ARGS=(
		# --without-libyaml doesn't disable trying to use libyaml
		# and results in automagic dep; --with-libyaml guarantees that
		# the build fails if the C extension fails to build
		--with-libyaml
	)
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}
	fi
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python OO interface to libcdio (CD Input and Control library)"
HOMEPAGE="
	https://savannah.gnu.org/projects/libcdio/
	https://github.com/rocky/pycdio/
	https://pypi.org/project/pycdio/
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="
	>=dev-libs/libcdio-2.0.0
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/swig
"

distutils_enable_tests pytest

python_prepare_all() {
	# Remove obsolete sys.path and adjust 'data' paths in examples.
	sed -i \
		-e "s:^sys.path.insert.*::" \
		-e "s:\.\./data:./data:g" \
		example/*.py || die
	# https://github.com/rocky/pycdio/pull/5
	sed -i -e 's:assertEquals:assertEqual:' test/test-*.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	epytest -opython_files='test-*.py'
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A configurable set of panels that display debug information"
HOMEPAGE="
	https://pypi.org/project/django-debug-toolbar/
	https://github.com/jazzband/django-debug-toolbar/"
SRC_URI="
	https://github.com/jazzband/django-debug-toolbar/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-1.11[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.2.0[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
	)
"

distutils_enable_sphinx docs

python_test() {
	emake TEST_ARGS='-v 2 tests' test
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}

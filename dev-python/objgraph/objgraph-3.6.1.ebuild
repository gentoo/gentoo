# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Draws Python object reference graphs with graphviz"
HOMEPAGE="
	https://github.com/mgedmin/objgraph/
	https://pypi.org/project/objgraph/
"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="doc"

RDEPEND="
	media-gfx/graphviz
"
BDEPEND="
	test? (
		media-gfx/xdot
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# unhappy about pytest
		tests.py::AtAddrsTest::test_at_addrs
	)

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# CPython GC
				tests.py::ByTypeTest::test_new_garbage

				# repr() mismatch
				tests.py::StringRepresentationTest::test_short_repr_mocked_instance_method_bound
				tests.py::StringRepresentationTest::test_short_repr_mocked_instance_method_bound_with_mocked_name
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# TODO: figure out how to run doctests
	epytest tests.py
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/* )
	distutils-r1_python_install_all
}

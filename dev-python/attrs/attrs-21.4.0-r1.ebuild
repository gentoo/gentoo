# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Attributes without boilerplate"
HOMEPAGE="
	https://github.com/python-attrs/attrs/
	https://attrs.readthedocs.io/
	https://pypi.org/project/attrs/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		$(python_gen_cond_dep '
			dev-python/cloudpickle[${PYTHON_USEDEP}]
		' python3_{8..10})
		>=dev-python/hypothesis-3.6.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.3.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	[[ ${EPYTHON} == python3.11 ]] && EPYTEST_DESELECT+=(
		# https://github.com/python-attrs/attrs/issues/907
		tests/test_annotations.py::TestAnnotations::test_auto_attribs
		tests/test_annotations.py::TestAnnotations::test_annotations_strings
		'tests/test_init_subclass.py::test_init_subclass_vanilla[True]'
		tests/test_make.py::TestAutoDetect::test_detects_setstate_getstate
		tests/test_slots.py::TestClosureCellRewriting::test_closure_cell_rewriting
		tests/test_slots.py::TestClosureCellRewriting::test_inheritance
		'tests/test_slots.py::TestClosureCellRewriting::test_cls_static[True]'
		tests/test_slots.py::TestPickle::test_no_getstate_setstate_for_dict_classes
		tests/test_slots.py::TestPickle::test_no_getstate_setstate_if_option_false
		tests/test_slots.py::test_slots_super_property_get_shurtcut
	)

	epytest
}

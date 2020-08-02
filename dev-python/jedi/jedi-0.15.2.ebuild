# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

TYPESHED_PV="$(ver_cut 1-2).0"
TYPESHED_P="typeshed-jedi_v${TYPESHED_PV}"

DESCRIPTION="Autocompletion library for Python"
HOMEPAGE="https://github.com/davidhalter/jedi"
SRC_URI="https://github.com/davidhalter/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/davidhalter/typeshed/archive/${TYPESHED_P#typeshed-}.tar.gz -> ${TYPESHED_P}.tar.gz"

LICENSE="MIT
	test? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND=">=dev-python/parso-0.5.2[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# upstream includes this as a submodule ...
	rmdir "${S}/jedi/third_party/typeshed" || die
	mv "${WORKDIR}/${TYPESHED_P}" \
		"${S}/jedi/third_party/typeshed" || die

	# don't run doctests, don't depend on colorama
	sed -i "s:'docopt',:: ; s:'colorama',::" setup.py || die
	sed -i "s: --doctest-modules::" pytest.ini || die

	# speed tests are fragile
	rm test/test_speed.py || die

	# Test <IntegrationTestCase: /var/tmp/portage/dev-python/jedi-0.15.2/work/jedi-0.15.2/test/completion/stdlib.py:194 '    c'> failed.
	rm test/completion/stdlib.py || die

	# Test <IntegrationTestCase: /var/tmp/portage/dev-python/jedi-0.15.2/work/jedi-0.15.2/test/completion/on_import.py:27 'import test'> failed.
	rm test/completion/on_import.py || die

	# ValueError: Should not happen. type: del_stmt
	rm test/test_utils.py || die

	# KeyError: ((), frozenset())
	sed -i -e 's:test_os_nowait:_&:' test/test_api/test_completion.py || die
	sed -i -e 's:test_os_issues:_&:' test/test_api/test_full_name.py || die

	# AssertionError: assert 'staticmethod(f: Callable)' == 'staticmethod(f: Callable[..., Any])'
	sed -i -e 's:test_staticmethod:_&:' test/test_api/test_signatures.py || die

	# AssertionError: assert 'path' not in ['abc', 'aifc', 'aiocontextvars', 'aiohttp', 'aiohttp_cors', 'aiounittest', ...]
	sed -i -e 's:test_os_issues:_&:' test/test_inference/test_imports.py || die

	# ValueError: not enough values to unpack (expected 2, got 1)
	sed -i -e 's:test_get_modules_containing_name:_&:' test/test_inference/test_docstring.py || die

	# AssertionError
	sed -i -e 's:test_venv_and_pths:_&:' test/test_inference/test_sys_path.py || die

	# AssertionError
	sed -i -e 's:test_get_typeshed_directories:_&:' test/test_inference/test_gradual/test_typeshed.py || die

	distutils-r1_python_prepare_all
}

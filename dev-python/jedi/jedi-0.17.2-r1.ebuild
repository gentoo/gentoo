# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

TYPESHED_P="typeshed-jedi_v0.16.0"
DJANGO_STUBS_P="django-stubs-v1.5.0"

DESCRIPTION="Autocompletion library for Python"
HOMEPAGE="https://github.com/davidhalter/jedi"
SRC_URI="
	https://github.com/davidhalter/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/davidhalter/typeshed/archive/${TYPESHED_P#typeshed-}.tar.gz
		-> ${TYPESHED_P}.tar.gz
	https://github.com/davidhalter/django-stubs/archive/${DJANGO_STUBS_P#django-stubs-}.tar.gz
		-> ${DJANGO_STUBS_P/v/}.tar.gz"

LICENSE="MIT
	test? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv ~sparc x86"

RDEPEND="=dev-python/parso-0.7*[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_prepare_all() {
	# upstream includes these as submodules ...
	rmdir "${S}"/jedi/third_party/{django-stubs,typeshed} || die
	mv "${WORKDIR}/${DJANGO_STUBS_P/v/}" \
		"${S}/jedi/third_party/django-stubs" || die
	mv "${WORKDIR}/${TYPESHED_P}" \
		"${S}/jedi/third_party/typeshed" || die

	# don't run doctests, don't depend on colorama
	sed -i "s:'docopt',:: ; s:'colorama',::" setup.py || die
	sed -i "s: --doctest-modules::" pytest.ini || die

	# test_complete_expanduser relies on $HOME not being empty
	> "${HOME}"/somefile || die

	distutils-r1_python_prepare_all
}

python_test() {
	local deselect=(
		# TODO
		'test/test_integration.py::test_completion[stdlib:197]'
		'test/test_integration.py::test_completion[on_import:29]'
		# assume pristine virtualenv
		test/test_utils.py::TestSetupReadline::test_local_import
		test/test_inference/test_imports.py::test_os_issues
	)
	[[ ${EPYTHON} == python3.10 ]] && deselect+=(
		# new features increased the match count again
		test/test_utils.py::TestSetupReadline::test_import

	)

	# django and pytest tests are very version dependent
	epytest ${deselect[@]/#/--deselect } -k "not django and not pytest"
}

# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Bootstrap3 template pack for django-crispy-forms"
HOMEPAGE="
	https://github.com/django-crispy-forms/crispy-bootstrap3/
	https://pypi.org/project/crispy-bootstrap3/
"
SRC_URI="
	https://github.com/django-crispy-forms/crispy-bootstrap3/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/django-5.2[${PYTHON_USEDEP}]
	>=dev-python/django-crispy-forms-2.0[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${P}-django52Py.patch )

python_prepare_all() {
	pushd tests/results/bootstrap3/test_form_helper 2>/dev/null
	cp bootstrap_form_show_errors_bs3_true_gte5{0,2}.html || die
	cp bootstrap_form_show_errors_bs3_false_gte5{0,2}.html || die
	cp test_form_show_errors_non_field_errors_true_gte5{0,2}.html || die
	cp test_form_show_errors_non_field_errors_false_gte5{0,2}.html || die
	popd
	eapply "${FILESDIR}"/${P}-django52.patch
	distutils-r1_python_prepare_all
}

EPYTEST_PLUGINS=( pytest-django )
distutils_enable_tests pytest

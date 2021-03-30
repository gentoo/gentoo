# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_P=django-rest-framework-${PV}
DESCRIPTION="Web APIs with django made easy"
HOMEPAGE="https://www.django-rest-framework.org/"
SRC_URI="
	https://github.com/encode/django-rest-framework/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/django-1.11[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/coreapi[${PYTHON_USEDEP}]
		dev-python/coreschema[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# TODO
		tests/test_description.py::TestViewNamesAndDescriptions::test_markdown
	)

	epytest ${deselect[@]/#/--deselect }
}

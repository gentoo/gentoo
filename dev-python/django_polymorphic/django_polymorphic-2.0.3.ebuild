# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Seamless Polymorphic Inheritance for Django Models"
HOMEPAGE="https://pypi.org/project/django-polymorphic/"

# pypi tarball does not include 'models.py' and 'admintestcase.py' from test directory
SRC_URI="https://github.com/django-polymorphic/django-polymorphic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-1.11[$PYTHON_USEDEP]
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/django-setuptest-0.2.1[${PYTHON_USEDEP}]
		dev-python/dj-database-url[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${P//_/-}"

python_test() {
	"${EPYTHON}" runtests.py || die "Tests fail with ${EPYTHON}"
}

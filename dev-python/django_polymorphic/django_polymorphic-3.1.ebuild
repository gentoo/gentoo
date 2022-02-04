# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Seamless Polymorphic Inheritance for Django Models"
HOMEPAGE="https://pypi.org/project/django-polymorphic/"
SRC_URI="
	https://github.com/django-polymorphic/django-polymorphic/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
S="${WORKDIR}/${P//_/-}"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-2.1[$PYTHON_USEDEP]
"

DEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
		dev-python/dj-database-url[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" runtests.py || die "Tests fail with ${EPYTHON}"
}

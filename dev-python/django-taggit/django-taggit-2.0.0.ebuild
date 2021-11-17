# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Simple tagging for Django"
HOMEPAGE="https://github.com/jazzband/django-taggit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-2.2[${PYTHON_USEDEP}]
	dev-python/djangorestframework[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( ${RDEPEND} )"

python_test() {
	"${EPYTHON}" -m django test -v 2 --settings=tests.settings ||
		die "Tests failed with ${EPYTHON}"
}

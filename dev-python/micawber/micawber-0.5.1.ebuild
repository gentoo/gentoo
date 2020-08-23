# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="A small library for extracting rich content from urls"
HOMEPAGE="https://github.com/coleifer/micawber/"
SRC_URI="https://github.com/coleifer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
	)"

python_test() {
	"${EPYTHON}" runtests.py || die "Tests failed with ${EPYTHON}"
}

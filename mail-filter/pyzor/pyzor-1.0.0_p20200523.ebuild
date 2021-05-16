# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

COMMIT="f46159bd6519cebcebf59e9334a7920371111d75"

DESCRIPTION="A distributed, collaborative spam detection and filtering network"
HOMEPAGE="https://github.com/SpamExperts/pyzor"
SRC_URI="https://github.com/SpamExperts/pyzor/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

IUSE="doc gdbm gevent mysql pyzord redis test"
RESTRICT="!test? ( test )"

RDEPEND="
	pyzord? (
		gdbm? ( $(python_gen_impl_dep 'gdbm') )
		gevent? ( dev-python/gevent[${PYTHON_USEDEP}] )
		mysql? ( dev-python/mysqlclient[${PYTHON_USEDEP}] )
		redis? ( dev-python/redis-py[${PYTHON_USEDEP}] )
	)"
DEPEND="
	test? (
		gdbm? ( $(python_gen_impl_dep 'gdbm') )
		redis? ( dev-python/redis-py[${PYTHON_USEDEP}] )
	)
"
BDEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

# TODO: maybe upstream would support skipping tests for which the
# dependencies are missing?
REQUIRED_USE="
	pyzord? ( || ( gdbm redis ) )
	test? ( gdbm redis )
"

S="${WORKDIR}/${PN}-${COMMIT}"

distutils_enable_sphinx "docs"

python_test() {
	pytest -vv tests/unit || die "Tests fail with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install

	if use pyzord; then
		dodir /usr/sbin
		mv "${ED}"/usr/bin/pyzord* "${ED}/usr/sbin" \
		   || die "failed to relocate pyzord"
	else
		rm "${ED}"/usr/bin/pyzord* || die "failed to remove pyzord"
	fi
}

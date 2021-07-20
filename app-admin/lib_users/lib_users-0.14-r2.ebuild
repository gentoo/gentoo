# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7..10} )

inherit python-r1

DESCRIPTION="Check for mapped libs and open files that are marked as deleted"
HOMEPAGE="https://github.com/klausman/lib_users"
SRC_URI="https://github.com/klausman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"
RDEPEND="${PYTHON_DEPS}"

src_test() {
	python_foreach_impl nosetests --verbosity=2
}

my_install() {
	python_newscript lib_users.py lib_users
	python_newscript fd_users.py fd_users
	# lib_users_util/ contains a test script we don't want, so do things by hand
	python_moduleinto lib_users_util
	python_domodule lib_users_util/common.py
	python_domodule lib_users_util/__init__.py
}

src_install() {
	python_foreach_impl my_install
	dodoc README.md TODO
}

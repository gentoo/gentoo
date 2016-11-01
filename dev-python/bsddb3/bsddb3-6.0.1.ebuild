# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="threads(+)"

inherit db-use distutils-r1 multilib

DESCRIPTION="Python bindings for Berkeley DB"
HOMEPAGE="http://www.jcea.es/programacion/pybsddb.htm https://pypi.python.org/pypi/bsddb3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND=">=sys-libs/db-4.8.30
	<sys-libs/db-6.1"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DISTUTILS_IN_SOURCE_BUILD=1

src_prepare() {
	# This list should be kept in sync with setup.py.
	for DB_VER in 6.0 5.3 5.2 5.1 5.0 4.8; do
		has_version "sys-libs/db:${DB_VER}" && break
	done

	# Force version.
	sed -e "s/db_ver = None/db_ver = (${DB_VER%.*}, ${DB_VER#*.})/" \
		-e "s/dblib = 'db'/dblib = '$(db_libname ${DB_VER})'/" \
		-i setup2.py setup3.py || die

	# Adjust test.py to look in build/lib.
	sed -e "s/'lib.%s' % PLAT_SPEC/'lib'/" \
		-i test2.py test3.py || die

	distutils-r1_src_prepare
}

src_configure() {
	# These are needed for both build and install.
	export BERKELEYDB_DIR="${EPREFIX}/usr"
	export BERKELEYDB_INCDIR="$(db_includedir)"
	export BERKELEYDB_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

python_compile() {
	if ! python_is_python3; then
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	fi
	distutils-r1_python_compile
}

python_test() {
	"${PYTHON}" test.py -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/html/. )
	distutils-r1_python_install_all
}

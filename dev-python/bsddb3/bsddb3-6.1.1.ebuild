# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads(+)"

inherit db-use distutils-r1 multilib

DESCRIPTION="Python bindings for Berkeley DB"
HOMEPAGE="http://www.jcea.es/programacion/pybsddb.htm https://pypi.python.org/pypi/bsddb3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	>=sys-libs/db-4.7:=
	<sys-libs/db-6.2:=
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DISTUTILS_IN_SOURCE_BUILD=1

src_prepare() {
	# This list should be kept in sync with setup.py.
	if [[ -z ${DB_VER} ]]; then
		for DB_VER in 6.1 6.0 5.3 5.2 5.1 5.0 4.8 4.7; do
			has_version "sys-libs/db:${DB_VER}" && break
		done
	fi

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
	export BERKELEYDB_INCDIR="$(db_includedir ${DB_VER})"
	export BERKELEYDB_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	export YES_I_HAVE_THE_RIGHT_TO_USE_THIS_BERKELEY_DB_VERSION=1
}

python_compile() {
	if ! python_is_python3; then
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	fi
	distutils-r1_python_compile
}

python_test() {
	if python_is_python3; then
		PYTHONPATH=Lib3 "${PYTHON}" test3.py -v || die "Testing failed with ${EPYTHON}"
	else
		PYTHONPATH=Lib "${PYTHON}" test.py -v || die "Testing failed with ${EPYTHON}"
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/html/. )
	distutils-r1_python_install_all
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_IN_SOURCE_BUILD=1
inherit db-use distutils-r1 pypi

DESCRIPTION="Python bindings for Berkeley DB"
HOMEPAGE="https://www.jcea.es/programacion/pybsddb.htm https://pypi.org/project/bsddb3/"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/patches/dev-python/${P}-fix-py3.10.patch.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	<sys-libs/db-6.1:=
	|| (
		sys-libs/db:5.3
		sys-libs/db:4.8
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}/${P}-fix-py3.10.patch"
)

python_prepare_all() {
	# This list should be kept in sync with setup.py.
	if [[ -z ${DB_VER} ]]; then
		for DB_VER in 5.3 4.8; do
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

	distutils-r1_python_prepare_all
}

python_configure_all() {
	# These are needed for both build and install.
	export BERKELEYDB_DIR="${EPREFIX}/usr"
	export BERKELEYDB_INCDIR="$(db_includedir ${DB_VER})"
	export BERKELEYDB_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	export YES_I_HAVE_THE_RIGHT_TO_USE_THIS_BERKELEY_DB_VERSION=1
}

python_test() {
	PYTHONPATH=Lib3 "${EPYTHON}" test3.py -vv || die "Testing failed with ${EPYTHON}"
}

# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_IN_SOURCE_BUILD=1
inherit db-use flag-o-matic distutils-r1

# Tests aren't included in PyPi tarballs, so just manually clone from upstream
# at https://hg.jcea.es/pybsddb/ and prepare out tarball

DESCRIPTION="Python bindings for Oracle Berkeley DB"
HOMEPAGE="https://www.jcea.es/programacion/pybsddb.htm https://pypi.org/project/berkeleydb/"
SRC_URI="https://dev.gentoo.org/~arthurzam/distfiles/dev-python/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	|| (
		sys-libs/db:6.2
		sys-libs/db:5.3
		sys-libs/db:4.8
	)"
DEPEND="${RDEPEND}"

python_prepare_all() {
	# This list should be kept in sync with setup3.py.
	if [[ -z ${DB_VER} ]]; then
		for DB_VER in 6.2 5.3 4.8; do
			has_version "sys-libs/db:${DB_VER}" && break
		done
	fi

	# Force version.
	sed -e "s/db_ver = None/db_ver = (${DB_VER%.*}, ${DB_VER#*.})/" \
		-e "s/dblib = 'db'/dblib = '$(db_libname ${DB_VER})'/" \
		-i setup3.py || die

	# rename to bypass name conflict with builtin test module
	mv test.py test3.py || die

	# Adjust test3.py to look in build/lib.
	sed -e "s/'lib.%s' % PLAT_SPEC/'lib'/" -i test3.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	# These are needed for both build and install.
	export BERKELEYDB_DIR="${EPREFIX}/usr"
	export BERKELEYDB_INCDIR="$(db_includedir ${DB_VER})"
	export BERKELEYDB_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	export YES_I_HAVE_THE_RIGHT_TO_USE_THIS_BERKELEY_DB_VERSION=1

	if use ia64; then
		# bug #814179
		append-flags -fno-optimize-sibling-calls
	fi
}

python_test() {
	"${EPYTHON}" test3.py -vv || die "Testing failed with ${EPYTHON}"
}

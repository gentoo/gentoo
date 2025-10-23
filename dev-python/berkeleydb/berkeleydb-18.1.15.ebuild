# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit db-use distutils-r1 pypi

DESCRIPTION="Python bindings for Oracle Berkeley DB"
HOMEPAGE="
	https://www.jcea.es/programacion/pybsddb.htm
	https://pypi.org/project/berkeleydb/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	<sys-libs/db-6.0:=
	|| (
		sys-libs/db:5.3
		sys-libs/db:4.8
	)
"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/test[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# This list should be kept in sync with setup.py.
	if [[ -z ${DB_VER} ]]; then
		for DB_VER in 5.3 4.8; do
			has_version "sys-libs/db:${DB_VER}" && break
		done
	fi

	# Force version.
	sed -e "s/db_ver = None/db_ver = (${DB_VER%.*}, ${DB_VER#*.})/" \
		-e "s/dblib = 'db'/dblib = '$(db_libname ${DB_VER})'/" \
		-i setup3.py || die

	# Fix the build
	mv setup3.py setup.py || die
	sed -e 's|setuptools.build_meta:__legacy__|setuptools.build_meta|' -i pyproject.toml || die

	# no build dir
	sed -e "/os.chdir('build')/d" -i test.py || die

	# Set it ourselves in the test phase
	sed -e "/os.environ\['BERKELEYDB_SO_PATH'\]/d" -i test.py || die
}

python_configure_all() {
	DISTUTILS_ARGS=(
		--berkeley-db="${EPREFIX}/usr"
		--berkeley-db-incdir="$(db_includedir ${DB_VER})"
		--berkeley-db-libdir="${EPREFIX}/usr/$(get_libdir)"
	)
}

python_test() {
	local -x BERKELEYDB_SO_PATH="${BUILD_DIR}"
	"${EPYTHON}" test.py -vv || die "Testing failed with ${EPYTHON}"
}

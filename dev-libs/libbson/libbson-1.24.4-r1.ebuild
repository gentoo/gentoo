# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} pypy3_11 )

inherit cmake python-any-r1

DESCRIPTION="Library routines related to building,parsing and iterating BSON documents"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver/tree/master/src/libbson"
SRC_URI="https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/mongo-c-driver-${PV}.tar.gz"
S="${WORKDIR}/mongo-c-driver-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~hppa ~loong ~mips ~ppc ~riscv ~s390 ~sparc x86"
IUSE="examples static-libs"

# tests are covered in mongo-c-driver and are not easily runnable in here
RESTRICT="test"

BDEPEND="
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/${P}-CVE-2023-0437.patch"
)

python_check_deps() {
	python_has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare

	# remove doc files
	sed -i '/^\s*install\s*(FILES COPYING NEWS/,/^\s*)/ {d}' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_EXAMPLES=OFF
		-DENABLE_MAN_PAGES=ON
		-DENABLE_MONGOC=OFF
		-DENABLE_TESTS=OFF
		-DENABLE_STATIC="$(usex static-libs ON OFF)"
		-DENABLE_UNINSTALL=OFF
	)

	cmake_src_configure
}

src_install() {
	if use examples; then
		docinto examples
		dodoc src/libbson/examples/*.c
	fi

	cmake_src_install
}

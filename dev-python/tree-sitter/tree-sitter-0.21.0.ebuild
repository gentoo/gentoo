# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

# Use the versions from the submodules under "tests/fixtures/"
declare -A TEST_FIXTURES=(
	["embedded-template"]="6d791b897ecda59baa0689a85a9906348a2a6414"
	["html"]="b5d9758e22b4d3d25704b72526670759a9e4d195"
	["javascript"]="de1e682289a417354df5b4437a3e4f92e0722a0f"
	["json"]="3b129203f4b72d532f58e72c5310c0a7db3b8e6d"
	["python"]="03e88c170cb23142559a406b6e7621c4af3128f5"
	["rust"]="3a56481f8d13b6874a28752502a58520b9139dc7"
)

DESCRIPTION="Python bindings to the Tree-sitter parsing library"
HOMEPAGE="
	https://github.com/tree-sitter/py-tree-sitter/
	https://pypi.org/project/tree-sitter/
"
SRC_URI="
	https://github.com/tree-sitter/py-tree-sitter/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
SRC_URI+=" test? ("
for fixture in "${!TEST_FIXTURES[@]}" ; do
	SRC_URI+="
		https://github.com/tree-sitter/tree-sitter-${fixture}/archive/${TEST_FIXTURES[${fixture}]}.tar.gz
			-> tree-sitter-${fixture}-${TEST_FIXTURES[${fixture}]}.tar.gz
	"
done
SRC_URI+=" )"
S=${WORKDIR}/py-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

# setuptools is needed for distutils import
DEPEND=">=dev-libs/tree-sitter-0.22.1"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	' 3.12)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/tree-sitter-0.21.0-unbundle.patch
)

src_unpack() {
	default
	rmdir "${S}/tree_sitter/core" || die

	if use test; then
		mkdir -p "${S}/tests/fixtures" || die
		local fixture
		for fixture in "${!TEST_FIXTURES[@]}" ; do
			mv -T "tree-sitter-${fixture}-${TEST_FIXTURES[${fixture}]}" "${S}/tests/fixtures/tree-sitter-${fixture}" || die
		done
	fi
}

src_test() {
	rm -r tree_sitter || die
	distutils-r1_src_test
}
